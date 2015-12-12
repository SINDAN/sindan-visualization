# Setup SINDAN Apps for Raspberry PI

* Requirements
OS: Raspbian (jessie)


* Install
** for production
$ ansible-playbook -i hosts/rpi.yml site.yml --ask-sudo-pass --ask-pass

* check scripts
$ ansible-playbook -i hosts/rpi.yml site.yml --check

* list of hosts
$ ansible-playbook -i hosts/rpi.yml site.yml --list-hosts

* list of tasks
$ ansible-playbook -i hosts/rpi.yml site.yml --list-tasks


* Manual Setup
** wifi settings
** sindan config
