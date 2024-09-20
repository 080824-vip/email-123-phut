
#!/bin/bash

# Cài đặt các gói cần thiết
apt-get update
apt-get install -y python3 python3-pip git

# Clone repository từ GitHub
git clone https://github.com/080824-vip/email-123-phut.git
cd email-123-phut

# Cài đặt các thư viện Python cần thiết
pip3 install -r requirements.txt gunicorn

# Cài đặt và cấu hình Nginx
apt-get install -y nginx
cat <<EOT > /etc/nginx/sites-available/email-123-phut
server {
    listen 8080;
    server_name _;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOT
rm -f /etc/nginx/sites-enabled/email-123-phut
ln -s /etc/nginx/sites-available/email-123-phut /etc/nginx/sites-enabled
nginx -t
systemctl restart nginx

# Chạy server Flask với Gunicorn
NUM_WORKERS=$(($(nproc) * 2))
nohup gunicorn -w $NUM_WORKERS -b 127.0.0.1:5000 app:app > server.log 2>&1 &
