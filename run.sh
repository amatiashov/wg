clear
sudo apt update
sudo apt install -y vim ufw apache2-utils

sudo ufw allow OpenSSH
sudo ufw --force enable

mkdir cert
# https://stackoverflow.com/a/10176685
openssl req -x509 -newkey rsa:4096 -keyout cert/private.key -out cert/public.pem -sha256 -days 3650 -nodes -subj "/L=City"
# https://gist.github.com/loskiq/f6d9348c8cfd8573a90cafda88a57392
openssl x509 -noout -sha256 -fingerprint -in cert/public.pem

# https://stackoverflow.com/a/66946735
export WG_HOST=$(curl ifconfig.me)
export RAW_WG_PASSWORD=$(openssl rand -base64 15)
# https://unix.stackexchange.com/a/419855
export PASSWORD_HASH=$(htpasswd -bnBC 10 "" ${RAW_WG_PASSWORD} | tr -d ':\n')

docker compose up -d

echo "https://${WG_HOST}:51821"
echo ${RAW_WG_PASSWORD}