from flask import Flask, render_template
import logging
from elasticapm.contrib.flask import ElasticAPM

app = Flask(__name__)

app.config['ELASTIC_APM'] = {
  'SERVICE_NAME': 'PythonTest',
  'SECRET_TOKEN': '',
  'SERVER_URL': 'https://apm.rudenspavasaris.id.lv',
  'ENVIRONMENT': 'production',
}

apm = ElasticAPM(app, logging=logging.INFO)

@app.route("/")
def home():
   return render_template("apm-rum.html")

if __name__ == "__main__":
  app.run(host='0.0.0.0')
