base:
  'minion_':
    #- common
    - containers.init
  '*mysql':
    - mysql.init
