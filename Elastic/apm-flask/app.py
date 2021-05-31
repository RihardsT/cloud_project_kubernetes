from flask import Flask

# initialize using environment variables
from elasticapm.contrib.flask import ElasticAPM
app = Flask(__name__)

# or configure to use ELASTIC_APM in your application's settings
from elasticapm.contrib.flask import ElasticAPM
app.config['ELASTIC_APM'] = {
  # Set the required service name. Allowed characters:
  # a-z, A-Z, 0-9, -, _, and space
  'SERVICE_NAME': 'PythonTest',
  # Use if APM Server requires a secret token
  'SECRET_TOKEN': '',
  # Set the custom APM Server URL (default: http://localhost:8200)
  'SERVER_URL': 'https://apm.rudenspavasaris.id.lv',
  # Set the service environment
  'ENVIRONMENT': 'production',
}

apm = ElasticAPM(app)
