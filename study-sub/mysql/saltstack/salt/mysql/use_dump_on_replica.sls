
include:
  - mysql.service
  - mysql.nfs_get_dump

mysql-master-dump:
  cmd.run:
    - name: "mysql -u root < /var/lib/mysql/dbdump.sql;"
    - require:
      - sls: mysql.service
      - sls: mysql.nfs_get_dump