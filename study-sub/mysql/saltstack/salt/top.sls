base:
  '*':
    - containers.init
  '*mysql':
    - mysql.mysql_setup.init
    - mysql.mysql_replication.orchestrate

# salt '*' state.apply -l debug <salt-state-name>
# salt '*' state.highstate
