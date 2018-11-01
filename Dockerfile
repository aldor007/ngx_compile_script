FROM debian:stretch
RUN apt-get update && apt-get install python python-yaml -y && apt-get install ruby ruby-dev rubygems build-essential sudo git wget tar unzip -y && ldconfig
RUN gem install --no-ri --no-rdoc fpm
WORKDIR /workspace
ADD . /workspace
RUN python compile.py
RUN ls /tmp/nginx-custom
ENV VERSION-$(cat /workspace/modules.yml | grep version | head -n 1 | awk  '{ gsub("\"", ""); print $2 }')
RUN cd /workspace; VERSION=$(cat /workspace/modules.yml | grep version | head -n 1 | awk  '{ gsub("\"", ""); print $2 }'); bash /workspace/debpackage.sh /tmp/nginx-custom/nginx/nginx-${VERSION}  ${VERSION}; mkdir -p /workspace/result; cp /workspace/nginx-extras-amd64-${VERSION}.deb /workspace/result
ENTRYPOINT ["cp" , "-r", "/workspace/result", "/result/"]
