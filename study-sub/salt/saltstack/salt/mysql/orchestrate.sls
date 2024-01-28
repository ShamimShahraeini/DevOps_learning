mysql_all:
  salt.state:
    - tgt: '*mysql'
    - sls:
      - containers.container-ssh-config

mysql_master:
  salt.state:
    - tgt: 'minion1-mysql'
    - sls:
      - mysql.master

mysql_replica:
  salt.state:
    - tgt: 'minion2-mysql'
      #- 'minion3-mysql'
    - sls:
      - mysql.replication

mysql_all_restart:
  salt.state:
    - tgt: '*mysql'
    - sls:
      - mysql.service
    - watch:
      - salt: mysql_master
      - salt: mysql_replica

#  on master > salt-run state.orchestrate mysql.orchestrate