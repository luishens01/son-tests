FROM python:3.4-slim
MAINTAINER SONATA

# Configuration
ENV broker_host amqp://guest:guest@broker:5672/%2F
ENV broker_exchange son-kernel

ADD . /app

WORKDIR /app

# we need to install in develop mode in order to use py.test
RUN python setup.py develop
# run all discovered unittests
CMD ["python", "listen.py",  "-v"]
