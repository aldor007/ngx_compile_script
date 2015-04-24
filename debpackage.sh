#!/bin/bash 
if [ $# -lt 2 ]; then
    echo "To few parametrs. Usage:"
    echo "debpackage source_dir version"
    exit 1
fi
source_dir=$1
deb_folder=/tmp/deb


mkdir -p $deb_folder
cp -r package/* $deb_folder
mkdir -p $deb_folder/usr/lib/x86_64-linux-gnu/perl5/5.20/nginx
mkdir -p $deb_folder/usr/sbin
mkdir -p $deb_folder/usr/share/perl5/5.20/
mkdir -p $deb_folder/etc/perl
mkdir -p $deb_folder/lib

cp $source_dir/conf/* $deb_folder/etc/nginx/ 
cp $source_dir/objs/nginx $deb_folder/usr/sbin/nginx 

sed -i s/%%VERSION%%/$2/g $source_dir/src/http/modules/perl/nginx.pm

cp $source_dir/objs/src/http/modules/perl/blib/arch/auto/nginx/nginx.so $deb_folder/lib 

cp $source_dir/src/http/modules/perl/nginx.pm $deb_folder/usr/share/perl5/5.20/
cp $source_dir/src/http/modules/perl/nginx.pm $deb_folder/usr/lib/x86_64-linux-gnu/perl5/5.20/
cp $source_dir/src/http/modules/perl/nginx.pm $deb_folder/usr/share/perl5/
cp $source_dir/src/http/modules/perl/nginx.pm $deb_folder/etc/perl/





fpm \
  -s dir \
  -t deb \
  -n nginx \
  -m "Marcin Kaciuba <marcin.kaciuba@gmail.com>" \
  --vendor "Local compilation" \
  --description "nginx web server" \
  --license "nonfree" \
  --url "https://mkaciuba.pl" \
  -p nginx-extras-amd64.deb \
  -v $2 \
  -C $deb_folder\
  -a all \
  --conflicts "nginx-extras.deb, nginx-extras, nginx-common, nginx-full" \
  --replaces "nginx-extras.deb, nginx-extras, nginx-common, nginx-full"  \
  -d libluajit-5.1-dev \
  -d perl-base \
  --pre-install scripts/preinstall \
  --post-install scripts/postinstall \

