pip3 install flask elastic-apm[flask]

flask run

while true; do
  curl localhost:5000 &>/dev/null
  sleep 2
done
