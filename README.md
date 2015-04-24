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

