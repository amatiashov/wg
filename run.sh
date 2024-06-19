clear
# https://stackoverflow.com/a/66946735
export WG_HOST=$(curl ifconfig.me)
export WG_PASSWORD=$(openssl rand -base64 15)
docker compose up -d
echo "${WG_HOST}:51821"
echo ${WG_PASSWORD}
