
include:
  - mysql.mysql_setup.service
  - mysql.nfs.nfs_get_dump

mysql-master-dump:
  cmd.run:
    - name: "mysql -u root < /var/lib/mysql/dbdump.sql;"
    - require:
      - sls: mysql.mysql_setup.service
      - sls: mysql.nfs.nfs_get_dump