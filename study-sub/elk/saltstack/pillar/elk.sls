containers:
  master:
    host: minion1-elastic
    ip: 192.168.56.11
    role: elastic-node
    enabled: true
    bind:
      address: 0.0.0.0
      port: 9200
    cluster:
      name: mytestcluster
      multicast: false
      members:
        - host: minion1-elastic
          port: 9300
        - host: minion2-elastic
          port: 9300
        - host: minion3-elastic
          port: 9300
    index:
      shards: 5
      replicas: 1
  replica1:
    host: minion2-elastic
    ip: 192.168.56.12
    role: elastic-node
  replica2:
    host: minion3-elastic
    ip: 192.168.56.13
    role: elastic-node
