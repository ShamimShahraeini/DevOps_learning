{% set replica_ip = salt['pillar.get']('replica1:ip') %}
{% set replica_user = salt['pillar.get']('replica1:user') %}
{% set replica_pass = salt['pillar.get']('replica1:pass') %}

## TODO: pillar > user, pass secure
mysql-master-createuser:
  cmd.run:
    - name: "mysql -e \"CREATE USER '{{ replica_user }}'@'{{ replica_ip }}' identified by '{{ replica_pass }}';\" "
    - unless: "mysql -N -e \"SELECT USER FROM mysql.user WHERE User='{{ replica_user }}' AND Host='{{ replica_ip }}';\" | grep -q '{{ replica_user }}'"
    - require_in:
      - sls: mysql.mysql_setup.service

mysql-master-allgrantuser:
  cmd.run:
    - name: "mysql -e \"grant replication slave on *.* to '{{ replica_user }}'@'{{ replica_ip }}';\" "
    - require:
      - cmd: mysql-master-createuser
    - require_in:
      - sls: mysql.mysql_setup.service

mysql-master-flush:
  cmd.run:
    - name: |
        systemctl restart mysql
        mysql -e "FLUSH PRIVILEGES;"
    - require:
      - cmd: mysql-master-allgrantuser
    - require_in:
      - sls: mysql.mysql_setup.service

include:
    - mysql.mysql_setup.service