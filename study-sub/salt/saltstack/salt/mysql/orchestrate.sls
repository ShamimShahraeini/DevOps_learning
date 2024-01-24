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
#    - require:

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

#  on master salt-run state.orchestrate mysql.orchestrate