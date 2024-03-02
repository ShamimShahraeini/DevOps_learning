base:
  '*':
    - containers.init
  '*mysql':
    - mysql.mysql_setup.init
    - mysql.mysql_replication.orchestrate
  '*memcached':
    - memcached.orchestrate
  '*elk':
    - elk.orchestrate
  '*redis':
    - redis.orchestrate

# salt '*' state.apply -l debug <salt-state-name>
# salt '*' state.highstate