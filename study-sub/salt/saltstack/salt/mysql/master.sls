{% set replica_ip = salt['pillar.get']('replica1:ip') %}

## TODO: pillar > user, pass secure
## TODO: check if user exists, dont run this
mysql-master-createuser:
  cmd.run:
    - name: "mysql -e \"CREATE USER 'replica'@'{{ replica_ip }}' identified by 'replica';\" "
    - unless: "mysql -N -e \"SELECT USER FROM mysql.user WHERE User='replica' AND Host='{{ replica_ip }}';\" | grep -q 'replica'"
    - require_in:
      - sls:  mysql.nfs_share_dump
      - sls: mysql.service

mysql-master-allgrantuser:
  cmd.run:
    - name: "mysql -e \"grant replication slave on *.* to 'replica'@'%';\" "
    - require:
      - cmd: mysql-master-createuser
    - unless: "mysql -N -e \"SELECT USER FROM mysql.user WHERE User='replica' AND Host='{{ replica_ip }}';\" | grep -q 'replica'"
    - require_in:
      - sls: mysql.nfs_share_dump
      - sls: mysql.service

mysql-master-flush:
  cmd.run:
    - name: "mysql -e \"FLUSH PRIVILEGES;\" "
    - require:
      - cmd: mysql-master-allgrantuser
    - require_in:
      - sls:  mysql.nfs_share_dump
      - sls: mysql.service

mysql-master-lock:
  cmd.run:
    - name: "mysql -e \"FLUSH TABLES WITH READ LOCK;\" "
    - require_in:
      - sls: mysql.nfs_share_dump
      - sls: mysql.service

mysql-master-dump:
  cmd.run:
    - name: "mysqldump -u root --all-databases > /var/lib/mysql/dbdump.sql"
    - unless: test -f /var/lib/mysql/dbdump.sql
    - require_in:
      - sls:  mysql.nfs_share_dump
      - sls: mysql.service

mysql-master-unlock:
  cmd.run:
    - name: "mysql -e \"UNLOCK TABLES;\" "
    - require_in:
      - sls: mysql.nfs_share_dump
      - sls: mysql.service

include:
    - mysql.service
    - mysql.nfs_share_dump

share_socalled_dumpfile:
  cmd.run:
    - name: cp /var/lib/mysql/dbdump.sql /mnt/dbshareddir
    - require:
      - sls: mysql.service
      - sls: mysql.nfs_share_dump
