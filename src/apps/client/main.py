from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello from minimal azd!"

@app.route("/health")
def health():
    """Health check endpoint for container health probes"""
    return {"status": "healthy"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
