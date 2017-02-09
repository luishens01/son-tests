FROM python:3.4-slim
MAINTAINER SONATA

# define plugin name once
#ENV PLUGIN_BASE son-mano-example-plugin-1
# Configuration
ENV broker_host amqp://guest:guest@broker:5672/%2F
ENV broker_exchange son-kernel
ENV instance_uuid aaaaa

RUN apt-get update && apt-get install -y \
	python2.7 \
	python-pip \
	python-dev \
	python-setuptools;

RUN pip install --upgrade pip;
RUN pip install --upgrade virtualenv;
RUN pip install python-keystoneclient;
RUN pip install python-heatclient;

# add generic project files
ADD son-mano-base /son-mano-base
ADD utils/delayedstart.sh /delayedstart.sh

# add plugin related files
ADD setup /plugin
ADD test-cleaner /plugin/test-cleaner
ADD clean.sh /plugin/test-cleaner

# install son-mano-base to be able to use the plugin base class etc.
WORKDIR /son-mano-base
RUN python setup.py install

# install actual plugin
WORKDIR /plugin
RUN python setup.py develop
WORKDIR /plugin/test-cleaner

CMD ['/plugin/test-cleaner/clean.sh']


