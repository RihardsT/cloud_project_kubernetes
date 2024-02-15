FROM python:3-alpine
RUN mkdir /flask
WORKDIR /flask
RUN pip install --upgrade pip && pip install --no-cache-dir flask elastic-apm[flask]
COPY . /flask

EXPOSE 5000
CMD [ "python", "app.py" ]
