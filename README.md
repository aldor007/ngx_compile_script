# ngx_compile_script
Python script for compile nginx
## Usage
```
python compile.py
```
The Script compile nginx in directory /tmp/nginx/nginx-VERSION
## Configuration
Everything is in file modules.yml (nginx version, list of modules,  flags to compile nginx)

## Create debian package
### Requirements
You need to have installed fpm
```
apt-get install ruby-dev gem
gem install fpm
```
### Usage
```
./debpackage.sh SOURCE_DIR VERSION
```
# Docker
Built using docker
```
docker build . -t nginx-custom
docker run -it --name=nginx-custom nginx-customa
docker cp  nginx-custom:/workspace/nginx-extras-amd64-1.13.7.deb .
``
