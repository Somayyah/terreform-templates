import azure.ai.vision as vision
import imghdr

# Define your Azure credentials and endpoint
key = "KEY"
endpoint = "ENDPOINT"

# Initialize the Azure Computer Vision client
## client = vision.VisionServiceOptions(endpoint, key)

analysis_options = vision.ImageAnalysisOptions()
analysis_options.language = "en"
analysis_options.gender_neutral_caption = True

feature_map = {
    'O': vision.ImageAnalysisFeature.OBJECTS,
    'C': vision.ImageAnalysisFeature.CAPTION,
    'P': vision.ImageAnalysisFeature.PEOPLE,
    'T': vision.ImageAnalysisFeature.TEXT,
    'G': vision.ImageAnalysisFeature.TAGS,
}

def analyze_image(feature, image_file):
    try:
        analysis_options.features = (feature,)
        vision_source = vision.VisionSource(url=image_file)
        # Replace the print statement with actual Azure CV API call
        print(f"Analyzing {feature} in {image_file}")
        # Example: response = client.analyze_image(vision_source, analysis_options)
        # Process and display the response here
    except Exception as e:
        print(f"An error occurred: {e}")

def is_image(file_path):
    return imghdr.what(file_path) is not None

def main():
    image_file = input("Welcome to AI image analyzer, Please enter the image path: ")

    if is_image(image_file):
        while True:
            option = input("""Select what feature to use in image analysis:
[O] - Objects
[C] - Captioning
[P] - People
[T] - Text
[G] - Tags
[Q] - Quit
Your choice: """).upper()

            if option == 'Q':
                print("\nExiting program.")
                break
            elif option in feature_map:
                analyze_image(feature_map[option], image_file)
            else:
                print("Invalid option, please try again.")
    else:
        print("The file is not an image.")

if __name__ == "__main__":
    main()
