base:
  '*':
    - containers.init
  '*memcached':
    - memcached.orchestrate

# salt '*' state.apply -l debug <salt-state-name>
# salt '*' state.highstate
