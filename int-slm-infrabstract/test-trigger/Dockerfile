FROM python:3.4-slim
MAINTAINER SONATA

# define plugin name once
#ENV PLUGIN_BASE son-mano-example-plugin-1
# Configuration
ENV broker_host amqp://guest:guest@broker:5672/%2F
ENV broker_exchange son-kernel

# add generic project files
ADD son-mano-base /son-mano-base
ADD utils/delayedstart.sh /delayedstart.sh

# add plugin related files
#ADD plugins/${PLUGIN_BASE} /plugins/${PLUGIN_BASE}
#ADD plugins/${PLUGIN_BASE}/test_trigger/test_descriptors /test_descriptors
ADD setup /plugin
ADD test_trigger /plugin/test_trigger
ADD ./test_trigger/test_descriptors /test_descriptors

# install son-mano-base to be able to use the plugin base class etc.
WORKDIR /son-mano-base
RUN python setup.py install

# install actual plugin
WORKDIR /plugin
RUN python setup.py develop
WORKDIR /plugin/test_trigger

CMD python3.4 exampleplugin.py


