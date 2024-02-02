{% set master_ip = salt['pillar.get']('master:ip') %}

mysql-replication-configfile_append:
  file.append:
    - name: /etc/mysql/my.cnf
    - text:
      - log-replica-updates=ON
      - skip-replica-start=ON
      - relay-log=mysql-relay-bin
    - require_in:
      - cmd: mysql-replication_stop
      - sls: mysql.service

mysql-replication_stop:
  cmd.run:
    - name: "mysql -e \"STOP REPLICA;\" "
    - require:
      - sls: mysql.service

mysql-replication_config:
  cmd.run:
    - name: "mysql -e \"CHANGE REPLICATION SOURCE TO SOURCE_HOST = '{{ master_ip }}', SOURCE_USER = 'replica',
SOURCE_PASSWORD = 'replica', SOURCE_AUTO_POSITION = 1, GET_MASTER_PUBLIC_KEY=1;\" "
    - unless: "mysql -e  \"SHOW REPLICA STATUS;\" | grep \"Slave_SQL_Running: Yes\" "


mysql-replication_start:
  cmd.run:
    - name: "mysql -e \"START REPLICA;\" "

include:
  - mysql.service



