# Setup SINDAN fluentd Server

* Requirements
OS: Raspbian (jessie)


* Install
** for production
$ ansible-playbook -i hosts/rpi.yml site.yml --list-hosts

$ ansible-playbook -i hosts/rpi.yml site.yml --ask-sudo-pass --ask-pass
