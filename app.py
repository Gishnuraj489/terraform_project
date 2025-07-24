from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello, CHEIF! The war between you [Gems] and the [Terraform] has come to an end. You have successfully deployed your sample application by conquering Terraform. Now, you can use this victory to build more complex infrastructures and applications. Remember, with great power comes great responsibility. Use it wisely! "

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)