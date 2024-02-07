{% set master_ip = salt['pillar.get']('containers:master:ip') %}
{% set replica_user = salt['pillar.get']('containers:master:user') %}
{% set replica_pass = salt['pillar.get']('containers:master:pass') %}

mysql-replication-configfile-append:
  file.append:
    - name: /etc/mysql/my.cnf
    - text:
      - log-replica-updates=ON
      - skip-replica-start=ON
      - relay-log=mysql-relay-bin
    - require_in:
      - cmd: mysql-replication-stop
      - sls: mysql.mysql_setup.service

mysql-restart-if-config-changes:
  cmd.run:
    - name: systemctl restart mysql
    - watch:
      - mysql-replication-configfile-append

mysql-replication-stop:
  cmd.run:
    - name: "mysql -e \"STOP REPLICA;\" "
    - require:
      - sls: mysql.mysql_setup.service

mysql-replication-config:
  cmd.run:
    - name: "mysql -e \"CHANGE REPLICATION SOURCE TO SOURCE_HOST = '{{ master_ip }}', SOURCE_USER = '{{ replica_user }}', SOURCE_PASSWORD = '{{ replica_pass }}', SOURCE_AUTO_POSITION = 1, GET_MASTER_PUBLIC_KEY=1;\" "
    - unless: "mysql -e  \"SHOW REPLICA STATUS;\" | grep \"Slave_SQL_Running: Yes\" "

mysql-replication-start:
  cmd.run:
    - name: "mysql -e \"START REPLICA;\" "

mysql-reset-master:
  cmd.run:
    - name: "mysql -e \"RESET MASTER;\" "

include:
  - mysql.mysql_setup.service
