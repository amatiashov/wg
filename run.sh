clear
sudo apt update
sudo apt install -y vim ufw apache2-utils

sudo ufw allow OpenSSH
sudo ufw --force enable


# Install docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce

# Install docker compose
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.29.2/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose


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