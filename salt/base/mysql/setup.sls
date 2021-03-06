#TODO: Version the following packages
install mysql dependencies:
  pkg.installed:
    - pkgs:
      - debconf-utils
      - python-dev
      - libmysqlclient-dev
      - python-mysqldb

setup mysql options via debconf util:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'password', 'value': '{{ salt['pillar.get']('mysql:root_pw', '') }}' }
        'mysql-server/root_password_again': {'type': 'password', 'value': '{{ salt['pillar.get']('mysql:root_pw', '') }}' }
    - require:
      - pkg: "install mysql dependencies"

install mysql server:
  pkg.installed:
    - name: mysql-server
    - require:
      - debconf: "setup mysql options via debconf util"
      - pkg: "install mysql dependencies"

#TODO: This is flaky, complains eventhough my.cnf file exists
#  service.running:
#    - name: mysql
#    - init_delay: 5
#    - watch:
#      - pkg: mysql-server
#      - file: /etc/mysql/my.cnf


#TODO: Create jinja templates for mysql configs & integrate with salt
#  - Ref: https://www.digitalocean.com/community/tutorials/saltstack-infrastructure-creating-salt-states-for-mysql-database-servers#create-the-etcmysqlmycnfjinja-template
#  file.managed:
#    - name: /etc/mysql/my.cnf
#    - source: salt://mysql/files/etc/mysql/my.cnf.jinja
#    - template: jinja
#    - user: root
#    - group: root
#    - mode: 640
#    - require:
#      - pkg: mysql-server
#
#  file.managed:
#    - name: /etc/salt/minion.d/mysql.conf
#    - source: salt://mysql/files/etc/salt/minion.d/mysql.conf
#    - user: root
#    - group: root
#    - mode: 640
#    - require:
#      - service: mysql
#
#  file.managed:
#    - name: /etc/mysql/salt.cnf
#    - source: salt://mysql/files/etc/mysql/salt.cnf.jinja
#    - template: jinja
#    - user: root
#    - group: root
#    - mode: 640
#    - require:
#      - service: mysql
#
#restart_minion_for_mysql:
#  service.running:
#    - name: salt-minion
#    - watch:
#      - file: /etc/salt/minion.d/mysql.conf
