# mysql_all:
#   salt.state:
#     - tgt: '*mysql'
#     - sls:
#       - mysql.mysql_setup.init

mysql_master:
  salt.state:
    - tgt: 'minion1db-mysql'
    - sls:
      - mysql.mysql_replication.master

mysql_replica:
  salt.state:
    - tgt: 'minion2db-mysql'
    - sls:
      - mysql.mysql_replication.replication

mysql_dump_master:
  salt.state:
    - tgt: 'minion1db-mysql'
    - sls:
       - mysql.mysql_replication.dump_master_data

mysql_replica_use_dump:
  salt.state:
    - tgt: 'minion2db-mysql'
    - sls:
      - mysql.mysql_replication.use_dump_on_replica

mysql_all_restart:
  salt.state:
    - tgt: '*mysql'
    - sls:
      - mysql.mysql_setup.service
    - watch:
      - salt: mysql_master
      - salt: mysql_replica

#  on master > salt-run state.orchestrate mysql.mysql_replication.orchestrate