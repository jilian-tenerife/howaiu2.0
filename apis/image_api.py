from flask import Flask, request, jsonify
import cv2
import numpy as np
import base64
from io import BytesIO
from PIL import Image

app = Flask(__name__)
face_emotion_recognizer = cv2.face.FisherFaceRecognizer_create()
face_emotion_recognizer.read(
    "fisherface_model.xml"
)

face_detector = cv2.CascadeClassifier(
    cv2.data.haarcascades + "haarcascade_frontalface_default.xml"
)

EMOTIONS = [
    "anger",
    "disgust",
    "fear",
    "happy",
    "sad",
    "surprise",
    "neutral",
]  # Assumed emotions~


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
    app.run(host="0.0.0.0", port=5000)
