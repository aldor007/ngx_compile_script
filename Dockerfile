FROM debian:trixie
RUN apt-get update && apt-get install python3 python3-yaml python-is-python3 -y && apt-get install ruby ruby-dev build-essential sudo git wget tar unzip -y && ldconfig
RUN gem install --no-document fpm
WORKDIR /workspace
ADD . /workspace
RUN python compile.py
RUN ls /tmp/nginx-custom
RUN cd /workspace; VERSION=$(cat /workspace/modules.yml | grep version | head -n 1 | awk  '{ gsub("\"", ""); print $2 }'); bash /workspace/debpackage.sh /tmp/nginx-custom/nginx/nginx-${VERSION}  ${VERSION}; mkdir -p /workspace/result; cp /workspace/nginx-extras-amd64-${VERSION}.deb /workspace/result
ENTRYPOINT ["cp" , "-r", "/workspace/result", "/result/"]
