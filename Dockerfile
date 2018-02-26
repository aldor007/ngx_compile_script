FROM debian:jessie
RUN apt-get update && apt-get install python python-yaml -y && apt-get install ruby ruby-dev rubygems build-essential sudo git wget tar unzip -y && ldconfig
RUN gem install --no-ri --no-rdoc fpm
WORKDIR /workspace
ADD . /workspace
RUN python compile.py
RUN ls /tmp/nginx-custom
RUN cd /workspace; bash /workspace/debpackage.sh /tmp/nginx-custom/nginx/nginx-1.13.9  1.13.9
ENTRYPOINT ["bash"]
