{% set replica_ip = salt['pillar.get']('replica1:ip') %}

## TODO: pillar > user, pass secure
mysql-master-createuser:
  cmd.run:
    - name: "mysql -e \"CREATE USER 'replica'@'{{ replica_ip }}' identified by 'replica';\" "
    - unless: "mysql -N -e \"SELECT USER FROM mysql.user WHERE User='replica' AND Host='{{ replica_ip }}';\" | grep -q 'replica'"
    - require_in:
      - sls: mysql.service

mysql-master-allgrantuser:
  cmd.run:
    - name: "mysql -e \"grant replication slave on *.* to 'replica'@'{{ replica_ip }}';\" "
    - require:
      - cmd: mysql-master-createuser
    - require_in:
      - sls: mysql.service

mysql-master-flush:
  cmd.run:
    - name: |
        systemctl restart mysql
        mysql -e "FLUSH PRIVILEGES;"
    - require:
      - cmd: mysql-master-allgrantuser
    - require_in:

      - sls: mysql.service

include:
    - mysql.service