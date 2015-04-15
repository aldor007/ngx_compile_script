import yaml
import os
import subprocess



config = yaml.load(open('./modules.yml'))
hooks = config['hooks']
env = os.environ
for key, value in config['enviroment'].iteritems():
    if value:
        env[key] = value


shell = lambda cmd: subprocess.call(cmd, shell=True, env = env)
base_path = '/tmp/'




def clone_repo(url, path, version):
    shell('git clone ' + url + ' ' + path)
    if version:
        shell('cd '+ path +' && git checkout ' + version)

def download(url, path):
    download_path = os.path.join(path, 'download')
    shell('mkdir -p ' + download_path)
    shell('wget -nc ' + url + ' -P ' +  download_path)

    if url.endswith('.tar.gz'):
        filename = url.split('/')
        filename = filename[len(filename) - 1]

        shell('tar zxf ' + os.path.join(download_path, filename) + ' -C ' + path)
        lst = [ name for name in os.listdir(path) if os.path.isdir(os.path.join(path, name)) and name[0] != '.' and name != 'download'  ]
        print(lst)
        return os.path.join(path, lst[0])
    return download_path


def prepare_modules(modules):
    modules_path = []
    for name, mod in modules.iteritems():
        path = os.path.join(base_path, name)
        if mod['source'].endswith('.git'):
            clone_repo(mod['source'], path, mod['version'])
        else:
            path = download(mod['source'], path)
        modules_path.append(path)
        if 'postdownload' in mod:
            for post in mod['postdownload']:
                shell('cd ' + path + ' && ' + post)
    return modules_path

def install_deps(deps):
    for dep in deps:
        shell('sudo apt-get install ' + dep)


def configure(args, modules):
    configure_args = ' --' + ' --'.join(args)
    for mod in modules:
        configure_args +=  ' --add-module=' + mod
    return configure_args





install_deps(config['install_deps'])
modules = prepare_modules(config['modules'])
configure_args = configure(config['configure'], modules)


nginx_path = download('http://nginx.org/download/nginx-' + config['version'] + '.tar.gz', os.path.join(base_path, 'nginx'))

print configure_args

shell('cd ' + nginx_path + ' && ./configure ' + configure_args)
if 'postconfigure' in hooks:
    if hooks['postconfigure']:
        for cmd in hooks['postconfigure']:
            cmd = cmd.replace('{{nginx_path}}', nginx_path)
            print(cmd)
            shell(cmd)



shell('cd ' + nginx_path + ' && make -j2')



