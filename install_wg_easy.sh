echo "⚙️ Activating Firewall..."
bash <(curl -Ls https://raw.githubusercontent.com/amatiashov/Shared-Scripts/refs/heads/main/activate_ufw.sh)

if ! command -v docker &> /dev/null; then
    echo "⚙️ Installing Docker..."
    bash <(curl -Ls https://raw.githubusercontent.com/amatiashov/Shared-Scripts/refs/heads/main/install_docker.sh)
else
    echo "Docker has been already installed"
fi

sudo apt install -y vim apache2-utils


mkdir cert
# https://stackoverflow.com/a/10176685
openssl req -x509 -newkey rsa:4096 -keyout cert/private.key -out cert/public.pem -sha256 -days 3650 -nodes -subj "/L=City"

# https://stackoverflow.com/a/66946735
export WG_HOST=$(curl ifconfig.me)
export RAW_WG_PASSWORD=$(openssl rand -base64 15)
# https://unix.stackexchange.com/a/419855
export PASSWORD_HASH=$(htpasswd -bnBC 10 "" ${RAW_WG_PASSWORD} | tr -d ':\n')

docker compose up -d

# https://gist.github.com/loskiq/f6d9348c8cfd8573a90cafda88a57392
openssl x509 -noout -sha256 -fingerprint -in cert/public.pem

echo "https://${WG_HOST}:65008"
echo ${RAW_WG_PASSWORD}