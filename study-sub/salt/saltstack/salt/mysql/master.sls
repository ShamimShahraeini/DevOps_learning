{% set replica_ip = '192.168.56.12' %}

## TODO: pillar > user, pass secure
## TODO: check if user exists, dont run this
mysql-master-createuser:
  cmd.run:
    - name: "mysql -e \"create user 'replica'@'{{ replica_ip }}' identified by 'replica';\" "

mysql-master-grantuser:
  cmd.run:
    - name: "mysql -e \"grant replication slave on *.* to 'replica'@'{{ replica_ip }}';\" "
    - require:
      - cmd: mysql-master-createuser

mysql-master-flush:
  cmd.run:
    - name: "mysql -e \"flush privileges;\" "
    - require:
      - cmd: mysql-master-grantuser

include:
    - mysql.service
    # - require_in:
    #   - mysql_query: mysql-master-createuser

    
