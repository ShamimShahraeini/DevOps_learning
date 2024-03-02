containers:
  memcache1:
    host: minion1-memcached
    ip: 192.168.56.11
    role: memcached-node
    enabled: true
    bind:
      address: 0.0.0.0
  memcache2:
    host: minion2-memcached
    ip: 192.168.56.12
    role: memcached-node
  mcrouter:
    host: minion3-mcrouter
    ip: 192.168.56.13
    role: mcrouter-node
