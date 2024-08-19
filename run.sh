clear
apt install -y apache2-utils

# https://stackoverflow.com/a/66946735
export WG_HOST=$(curl ifconfig.me)
export RAW_WG_PASSWORD=$(openssl rand -base64 15)
# https://unix.stackexchange.com/a/419855
export PASSWORD_HASH=$(htpasswd -bnBC 10 "" ${RAW_WG_PASSWORD} | tr -d ':\n')

docker compose up -d

echo "${WG_HOST}:51821"
echo ${RAW_WG_PASSWORD}