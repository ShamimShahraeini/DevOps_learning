base:
  '*':
    - containers.init
  '*elastic':
    - elk.elastic-setup

# salt '*' state.apply -l debug <salt-state-name>
# salt '*' state.highstate
