from flask import Flask, request, jsonify
import brainstorm_module  # Replace with the name of the file containing your AI code
import openai
import cv2
import numpy as np
import base64
from io import BytesIO
from PIL import Image

app = Flask(__name__)
previous_entries = []

openai.api_key = "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"

chat_history = []

face_emotion_recognizer = cv2.face.FisherFaceRecognizer_create()
face_emotion_recognizer.read("fisherface_model.xml")

face_detector = cv2.CascadeClassifier(cv2.data.haarcascades + "haarcascade_frontalface_default.xml")

EMOTIONS = ["anger", "disgust", "fear", "happy", "sad", "surprise", "neutral"]  # Assumed emotions

def load_image_from_data(data):
    img_data = base64.b64decode(data)
    image = Image.open(BytesIO(img_data))
    return np.array(image)  # RGB format

def find_user(new_img):
    new_img_gray = cv2.cvtColor(new_img, cv2.COLOR_RGB2GRAY)
    faces = face_detector.detectMultiScale(new_img_gray, 1.3, 5)
    if len(faces) > 0:
        for x, y, w, h in faces:
            face = new_img_gray[y : y + h, x : x + w]
            return cv2.resize(face, (48, 48))  # Assume the model expects 48x48 faces
    return None

def recognize_emotion(face):
    label, confidence = face_emotion_recognizer.predict(face)
    emotion = EMOTIONS[label]
    return emotion, confidence

@app.route('/title', methods=['POST'])
def generate_title():
    entry = request.json['entry']
    title = brainstorm_module.generate_title(entry)
    return jsonify({"title": title})

@app.route('/feedback', methods=['POST'])
def generate_feedback():
    entry = request.json['entry']
    feedback = brainstorm_module.generate_feedback(entry)
    return jsonify({"feedback": feedback})

@app.route('/emotional_rating', methods=['POST'])
def generate_emotional_rating():
    entry = request.json['entry']
    emotional_rating = brainstorm_module.generate_emotional_rating(entry)
    return jsonify({"emotional_rating": emotional_rating})

@app.route('/analytical_response', methods=['POST'])
def generate_analytical_response():
    entry = request.json['entry']
    analytical_response = brainstorm_module.generate_analytical_response(entry)
    return jsonify({"analytical_response": analytical_response})

@app.route('/contextual_response', methods=['POST'])
def generate_contextual_response():
    entry = request.json['entry']
    previous_entries.append(entry)
    past_entries = previous_entries[-3:]
    contextual_response = brainstorm_module.generate_contextual_response(entry, past_entries)
    return jsonify({"contextual_response": contextual_response})

@app.route('/summary', methods=['POST'])
def generate_summary():
    all_entries = request.json['all_entries']
    contextual_response = generate_summary(all_entries)
    return jsonify({"contextual_response": contextual_response})

@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json['message']
    name = request.json['name']

    chat_history.append(f"User: {user_message}")
    context = "\n".join(chat_history)

    chatbot_response = get_response(context, name)
    chat_history.append(chatbot_response)

    return jsonify({"response": chatbot_response})

@app.route("/find_and_recognize", methods=["POST"])
def find_and_recognize():
    data = request.get_json(force=True)

    new_image_data = data["new_image"]
    new_image = load_image_from_data(new_image_data)

    user_face = find_user(new_image)
    if user_face is not None:
        emotion, confidence = recognize_emotion(user_face)
        return jsonify({"emotion": emotion, "confidence": confidence})

    return jsonify({"error": "User not found in the new image"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5001)
