pip3 install -U flask elastic-apm[flask]

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

# APM RUM
https://github.com/elastic/apm-agent-rum-js/releases

How to run this?
Set up your Elastic stack as usual and
then you can open the templates/apm-rum.html in browser. It can be fine.
Plain html works right away, no need to set up webserver for this.
Though the Origin header is sent as null, which possibly could be necessary somewhere?
If so, then just run the flask app.

# If you wish to run it within container
docker build -t flask_apm_test_app .
docker run --rm -p 5000:5000 flask_apm_test_app
