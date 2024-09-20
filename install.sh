
#!/bin/bash

# Cài đặt các gói cần thiết
apt-get update
apt-get install -y python3 python3-pip git

# Clone repository từ GitHub
git clone https://github.com/080824-vip/email-123-phut.git
cd email-123-phut

# Cài đặt các thư viện Python cần thiết
pip3 install -r requirements.txt gunicorn

# Chạy server Flask với Gunicorn
# Sử dụng số lượng worker bằng 2-4 lần số lượng CPU
NUM_WORKERS=$(($(nproc) * 2))
nohup gunicorn -w $NUM_WORKERS -b 0.0.0.0:5000 app:app > server.log 2>&1 &
