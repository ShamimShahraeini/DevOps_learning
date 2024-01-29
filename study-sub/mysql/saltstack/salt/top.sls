base:
  '*':
    #- common
    - containers.init
  '*mysql':
    - mysql.init

# salt '*' state.apply -l debug
