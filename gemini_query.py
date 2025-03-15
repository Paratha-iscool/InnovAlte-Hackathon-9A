import requests
import json
import sys
import logging

# Set up logging to get detailed error information
logging.basicConfig(level=logging.DEBUG)

def query_gemini(api_key, prompt):
    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=GEMINI_API_KEY"
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
        logging.debug("Sending request to Gemini API...")
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()  # This will raise an exception for HTTP errors
        result = response.json()
        logging.debug("Received response from Gemini API: %s", result)

        if 'candidates' in result and result['candidates']:
            return result['candidates'][0]['content']['parts'][0]['text']
        else:
            return "No response from Gemini."

    except requests.exceptions.RequestException as e:
        logging.error("Request failed: %s", e)
        return f"Error: {e}"

    except json.JSONDecodeError as e:
        logging.error("JSON decoding failed: %s", e)
        return f"Error decoding JSON: {e}"

    except Exception as e:
        logging.error("An unexpected error occurred: %s", e)
        return f"Unexpected Error: {e}"

if __name__ == "__main__":
    # Make sure to validate that an argument is passed for the prompt
    if len(sys.argv) < 2:
        print("Usage: python gemini_query.py <prompt>")
        sys.exit(1)

    prompt = sys.argv[1]
    api_key = "AIzaSyCQ5sslSSzED7friNAeS4kut7wnmqLFqHY"

    logging.debug("Starting query with prompt: %s", prompt)

    response = query_gemini(api_key, prompt)
    print(response)

    
