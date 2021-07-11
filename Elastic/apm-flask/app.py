from flask import Flask
from elasticapm.contrib.flask import ElasticAPM

app = Flask(__name__)

app.config['ELASTIC_APM'] = {
  'SERVICE_NAME': 'PythonTest',
  'SECRET_TOKEN': '',
  'SERVER_URL': 'https://apm.rudenspavasaris.id.lv',
  'ENVIRONMENT': 'production',
}

apm = ElasticAPM(app)
