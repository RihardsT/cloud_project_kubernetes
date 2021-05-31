pip3 install elastic-apm[flask]

flask run

while true; do
  curl localhost:5000 &>/dev/null
  sleep 1
done
