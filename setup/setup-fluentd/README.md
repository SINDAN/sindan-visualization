# Setup SINDAN fluentd Server

* Requirements
OS: Ubuntu 14.04


* Install
** for production
$ ansible-playbook -i hosts/fluentd site.yml --list-hosts

$ ansible-playbook -i hosts/fluentd site.yml --ask-sudo-pass

** for development(vagrant)
$ ansible-playbook -i hosts/vagrant site.yml --list-hosts

$ ansible-playbook -i hosts/vagrant site.yml

* check scripts
$ ansible-playbook -i hosts/fluentd site.yml --check

* list of hosts
$ ansible-playbook -i hosts/fluentd site.yml --list-tasks


* Manual Setup
