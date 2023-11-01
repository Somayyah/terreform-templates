import os 
from dotenv import load_dotenv

load_dotenv()

OPEN_AI_ENDPOINT=os.getenv('OPEN_AI_ENDPOINT')
OPEN_AI_KEY=os.getenv('OPEN_AI_KEY')
SPEECH_KEY=os.getenv('SPEECH_KEY')
SPEECH_REGION=os.getenv('SPEECH_REGION')
SUFFEX=os.getenv('SUFFEX')