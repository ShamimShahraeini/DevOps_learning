mysql_all:
  salt.state:
    - tgt: '*mysql'
    - sls:
      - mysql.init

mysql_master:
  salt.state:
    - tgt: 'minion1-mysql'
    - sls:
      - mysql.master

mysql_replica:
  salt.state:
    - tgt: 'minion2-mysql'
    - sls:
      - mysql.replication

mysql_dump_master:
  salt.state:
    - tgt: 'minion1-mysql'
    - sls:
       - mysql.dump_master_data

mysql_replica_use_dump:
  salt.state:
    - tgt: 'minion2-mysql'
    - sls:
      - mysql.use_dump_on_replica

mysql_all_restart:
  salt.state:
    - tgt: '*mysql'
    - sls:
      - mysql.service
    - watch:
      - salt: mysql_master
      - salt: mysql_replica

#  on master > salt-run state.orchestrate mysql.orchestrate