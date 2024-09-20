
from flask import Flask, request, jsonify
from email_validator import validate_email, EmailNotValidError
import random
import string

app = Flask(__name__)

# Tạo email tạm thời
def generate_temp_email(domain="tempmail.com"):
    username = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))
    return f"{username}@{domain}"

# Kiểm tra email hợp lệ
def is_valid_email(email):
    try:
        validate_email(email)
        return True
    except EmailNotValidError:
        return False

@app.route('/generate', methods=['GET'])
def generate_email():
    domain = request.args.get('domain', 'tempmail.com')
    temp_email = generate_temp_email(domain)
    return jsonify({"temp_email": temp_email})

@app.route('/validate', methods=['POST'])
def validate():
    data = request.get_json()
    email = data.get('email')
    if is_valid_email(email):
        return jsonify({"valid": True})
    else:
        return jsonify({"valid": False})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
