db_dump_address: /var/lib/mysql/dbdump.db
master:
  ip: 192.168.56.11
  role: db-master
  user: replica
  pass: replica
replica1:
  ip: 192.168.56.12
  role: db-rep1
  user: replica
  pass: replica
replica2:
  ip: 192168.56.13
  role: db-rep2
  user: replica
  pass: replica
