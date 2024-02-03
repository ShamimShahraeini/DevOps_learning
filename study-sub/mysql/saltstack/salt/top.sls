base:
  '*':
    - containers.init
  '*mysql':
    - mysql.init

# salt '*' state.apply -l debug <salt-state-name>
# salt '*' state.highstate
