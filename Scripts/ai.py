import requests
import json
import sys

def query_gemini(api_key, prompt):
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"
    headers = {
        "Content-Type": "application/json",
        "x-goog-api-key": api_key,
    }
    data = {
        "contents": [{
            "parts": [{
                "text": prompt
            }]
        }]
    }

    try:
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()  # Raise HTTPError for bad responses (4xx or 5xx)
        result = response.json()

        if 'candidates' in result and result['candidates']:
            return result['candidates'][0]['content']['parts'][0]['text']
        else:
            return "No response from Gemini."

    except requests.exceptions.RequestException as e:
        return f"Error: {e}"
    except json.JSONDecodeError as e:
        return f"Error decoding JSON: {e}"

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python gemini_query.py <api_key> <prompt>")
        sys.exit(1)

    api_key = sys.argv[1]
    prompt = sys.argv[2]

    response = query_gemini(api_key, prompt)
    print(response)