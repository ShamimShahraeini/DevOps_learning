containers:
  master:
    host: minion1-mysql
    ip: 192.168.56.11
    role: db-master
    user: replica
    pass: replica
    db_dump_address: /var/lib/mysql/dbdump.db
  replica1:
    host: minion2-mysql
    ip: 192.168.56.12
    role: db-replica
  replica2:
    host: minion3-mysql
    ip: 192.168.56.13
    role: db-replica

