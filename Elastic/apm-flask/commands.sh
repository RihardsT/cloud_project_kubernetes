pip3 install flask elastic-apm[flask]

flask run

while true; do
  curl localhost:5000 &>/dev/null
  sleep 2
done

# For dirty testing to force a "different client":
docker run --rm -ti --name apm_test ubuntu bash
apt update && apt install -y python3 python3-pip curl vim
pip3 install flask elastic-apm[flask]
# Then just run it as usual
docker exec -ti apm_test bash
