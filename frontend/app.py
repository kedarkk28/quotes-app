import os
import requests
from flask import Flask, render_template, jsonify

app = Flask(__name__)

BACKEND_URL = os.environ.get("BACKEND_URL", "http://backend-service:3000")


def fetch_quote():
    try:
        resp = requests.get(f"{BACKEND_URL}/api/quote", timeout=5)
        resp.raise_for_status()
        return resp.json()
    except requests.exceptions.ConnectionError:
        return {"text": "The backend is not reachable right now.", "author": "System", "error": True}
    except requests.exceptions.Timeout:
        return {"text": "The request timed out. Please refresh.", "author": "System", "error": True}
    except Exception as e:
        return {"text": str(e), "author": "System", "error": True}


@app.route("/")
def index():
    quote = fetch_quote()
    return render_template("index.html", quote=quote)


@app.route("/health")
def health():
    return jsonify({"status": "ok"}), 200


@app.route("/ready")
def ready():
    try:
        resp = requests.get(f"{BACKEND_URL}/health", timeout=3)
        if resp.status_code == 200:
            return jsonify({"status": "ready"}), 200
        return jsonify({"status": "not ready", "reason": "backend unhealthy"}), 503
    except Exception as e:
        return jsonify({"status": "not ready", "reason": str(e)}), 503


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)