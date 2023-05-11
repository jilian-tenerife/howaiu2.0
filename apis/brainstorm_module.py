import openai

openai.api_key = "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"

previous_entries = []

def generate_contextual_response(entry, past_entries):
    past_context = " ".join(past_entries[-3:])
    prompt = f'''As an AI-powered intelligent mobile diary, my task is to provide a response to the following diary entry, considering the past context:
Past Entries:
"{past_context}"
Current Entry:
"{entry}"
Response:
    '''
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=1000,
        n=1,
        stop=None,
        temperature=0.7,
    )

    return response.choices[0].text.strip()

def generate_title(entry):
    prompt = f'''As an AI-powered intelligent mobile diary, my task is to generate a title for the following diary entry:
"{entry}"
Title:
    '''
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=50,
        n=1,
        stop=None,
        temperature=0.7,
    )

    return response.choices[0].text.strip()

def generate_feedback(entry):
    prompt = f'''As an AI-powered intelligent mobile diary, my task is to provide exhaustive feedback on the following diary entry:
"{entry}"
Feedback:
    '''
    response = openai.Completion.create(
#         engine="text-davinci-003",
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=1000,
        n=1,
        stop=None,
        temperature=0.7,
    )

    return response.choices[0].text.strip()

def generate_emotional_rating(entry):
    prompt = f'''As an AI-powered intelligent mobile diary, my task is to rate the emotional state of the following diary entry on a scale of 0 to 10. I will just return the number only.:
"{entry}"
Emotional Rating:
    '''
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=25,
        n=1,
        stop=None,
        temperature=0.5,
    )

    return response.choices[0].text.strip()

def generate_analytical_response(entry):
    prompt = f'''As an AI-powered intelligent mobile diary, my task is to provide an analytical response that identifies any negative thought patterns or cognitive distortions in the following diary entry in first person:
"{entry}"
Analytical Response:
    '''
    response = openai.Completion.create(
        engine="text-davinci-003",
        prompt=prompt,
        max_tokens=1000,
        n=1,
        stop=None,
        temperature=0.7,
    )

    return response.choices[0].text.strip()