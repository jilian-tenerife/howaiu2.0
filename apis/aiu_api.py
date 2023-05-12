from flask import Flask, request, jsonify
import brainstorm_module  # Replace with the name of the file containing your AI code
import openai

app = Flask(__name__)

previous_entries = []


openai.api_key = "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"

chat_history = []


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

def generate_summary(entries):
    instruction = 'Understand the instructions step by step. These are a compilation of diary writings. Create insightful, critical, and objective assessments. Take note of context, crucial information, and entities and how it affects the person. If some topics relate to each other, analyze it. Address the person as "you". The writings: '
    prompt = instruction + ' '.join(entries)

    response = openai.Completion.create(
        engine='text-davinci-003',
        prompt=prompt,
        max_tokens=2000,
        n=1,
        stop=None,
        temperature=0.7,
    )
    print(response.choices[0].text.strip())
    return response.choices[0].text.strip()


def get_response(prompt, name):
    instruction = f'As an AI-powered intelligent chatbot named AIU, my task is to chat and give affirmations in first person, positive reinforcement, and critical psychoanalysis. I am a therapist and a friend to {name}. I will respond, not correct, nor complete. I will be very conversational and have a great personality. I am interesting.'
    prompt = instruction + prompt

    response = openai.Completion.create(
        engine='text-davinci-003',
        prompt=prompt,
        max_tokens=500,
        n=1,
        stop=None,
        temperature=0.7,
    )

    return response.choices[0].text.strip()


@app.route('/chat', methods=['POST'])
def chat():
    user_message = request.json['message']
    name = request.json['name']

    chat_history.append(f"User: {user_message}")
    context = "\n".join(chat_history)

    chatbot_response = get_response(context, name)
    chat_history.append(chatbot_response)

    return jsonify({"response": chatbot_response})


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
