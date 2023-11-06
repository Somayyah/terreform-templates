import os
import azure.cognitiveservices.speech as speechsdk
import openai
import json
from variables import *

openai.api_key = OPEN_AI_KEY
openai.api_base =  OPEN_AI_ENDPOINT
openai.api_type = 'azure'
openai.api_version = '2023-03-15-preview'
print(OPEN_AI_ENDPOINT)
# This will correspond to the custom name you chose for your deployment when you deployed a model.
deployment_id = "watari-ai-aoai-cd-" + SUFFEX

# This example requires environment variables named "SPEECH_KEY" and "SPEECH_REGION"
speech_config = speechsdk.SpeechConfig(subscription=os.getenv('SPEECH_KEY'), region=os.getenv('SPEECH_REGION'))
audio_output_config = speechsdk.audio.AudioOutputConfig(use_default_speaker=True)
audio_config = speechsdk.audio.AudioConfig(use_default_microphone=True)

# Should be the locale for the speaker's language.
speech_config.speech_recognition_language="en-US"
speech_recognizer = speechsdk.SpeechRecognizer(speech_config=speech_config, audio_config=audio_config)

# The language of the voice that responds on behalf of Azure OpenAI.
speech_config.speech_synthesis_voice_name='en-US-JennyMultilingualNeural'
speech_synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=audio_output_config)

# tts sentence end mark
tts_sentence_end = [ ".", "!", "?", ";", "。", "！", "？", "；", "\n" ]

# Prompts Azure OpenAI with a request and synthesizes the response.
def ask_openai(prompt):

    # Ask Azure OpenAI in streaming way
    responses = list(openai.ChatCompletion.create(engine=deployment_id, model="gpt-4", messages=[{"role": "user", "content": prompt}], max_tokens=200, stream=True))
    #print("response: " + str(responses))
    collected_messages = []
    last_tts_request = None
    for openai_object in responses:
        print(str(openai_object))
        # if hasattr(openai_object, 'choices'):
        #     for choice in openai_object.choices:
        #         print(choice)
                #if 'content' in choice['message']:
                #    collected_messages.append(choice['message']['content'])
    # iterate through the stream response stream
    complete_message = ''.join(collected_messages).strip()
    print(f"Complete message: {complete_message}")

    for chunk in complete_message:
        if len(chunk['choices']) > 0:
            chunk_message = chunk['choices'][0]['message']['content']  # extract the message content
            collected_messages.append(chunk_message)  # save the message
            if chunk_message in tts_sentence_end: # sentence end found
                text = ''.join(collected_messages).strip() # join the recieved message together to build a sentence
                if text != '': # if sentence only have \n or space, we could skip
                    print(f"Speech synthesized to speaker for: {text}")
                    last_tts_request = speech_synthesizer.speak_text_async(text)
                    collected_messages.clear()
    if last_tts_request:
        last_tts_request.get()

# Continuously listens for speech input to recognize and send as text to Azure OpenAI
def chat_with_open_ai():
    while True:
        print("Azure OpenAI is listening. Say 'Stop' or press Ctrl-Z to end the conversation.")
        try:
            # Get audio from the microphone and then send it to the TTS service.
            speech_recognition_result = speech_recognizer.recognize_once_async().get()
            print("Speech recognition result type: " + str(speech_recognition_result))
            # If speech is recognized, send it to Azure OpenAI and listen for the response.
            if speech_recognition_result.reason == speechsdk.ResultReason.RecognizedSpeech:
                if speech_recognition_result.text == "Stop.": 
                    print("Conversation ended.")
                    break
                print("Recognized speech: {}".format(speech_recognition_result.text))                
                ask_openai(speech_recognition_result.text)
            elif speech_recognition_result.reason == speechsdk.ResultReason.NoMatch:
                print("No speech could be recognized: {}".format(speech_recognition_result.no_match_details))
                break
            elif speech_recognition_result.reason == speechsdk.ResultReason.Canceled:
                cancellation_details = speech_recognition_result.cancellation_details
                print("Speech Recognition canceled: {}".format(cancellation_details.reason))
                if cancellation_details.reason == speechsdk.CancellationReason.Error:
                    print("Error details: {}".format(cancellation_details.error_details))
        except EOFError:
            break

# Main

try:
    #ask_openai("How are you?")
    chat_with_open_ai()
except Exception as err:
    print("Encountered exception. {}".format(err))