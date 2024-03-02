containers:
  master:
    host: minion1-redis
    ip: 192.168.56.11
    role: redis-master-node
  replica1:
    host: minion2-redis
    ip: 192.168.56.12
    role: redis-node
  replica2:
    host: minion3-redis
    ip: 192.168.56.13
    role: redis-node
