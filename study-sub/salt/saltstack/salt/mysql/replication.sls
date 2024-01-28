{% set master_ip = salt['pillar.get']('master:ip') %}

mysql-replication_stop:
  cmd.run:
    - name: "mysql -e \"STOP SLAVE;\" "
    - require_in:
      - sls: mysql.nfs_get_dump

mysql-replication_config:
  cmd.run:
    - name: "mysql -e \"CHANGE MASTER TO MASTER_HOST='{{ master_ip }}', MASTER_USER='replica', MASTER_PASSWORD='replica', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=624;\" "
    - unless: "mysql -e  \"SHOW SLAVE STATUS;\" | grep \"Slave_SQL_Running: Yes\" "
    - require_in:
      - sls: mysql.nfs_get_dump

mysql-replication_start:
  cmd.run:
    - name: "mysql -e \"START SLAVE;\" "
    - require_in:
      - sls: mysql.nfs_get_dump

include:
  - mysql.nfs_get_dump

mysql-master-dump:
  cmd.run:
    - name: "mysql -u root < /var/lib/mysql/dbdump.sql;"
    - require:
      - sls: mysql.nfs_get_dump


