{% set master_ip = '192.168.56.11' %}

mysql-replication_config:
  cmd.run:
    - name: "mysql -e \"CHANGE MASTER TO MASTER_HOST='{{ master_ip }}', MASTER_USER='replica', MASTER_PASSWORD='replica', MASTER_LOG_FILE='mysql-bin.000001', MASTER_LOG_POS=624;\" "

mysql-replication_start:
  cmd.run:
    - name: "mysql -e \"start slave;\" "



