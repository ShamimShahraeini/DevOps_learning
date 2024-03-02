mysql-master-lock:
  cmd.run:
    - name: "mysql -e \"FLUSH TABLES WITH READ LOCK;\" "
    - require_in:
      - sls: mysql.nfs.nfs_share_dump
      - sls: mysql.mysql_setup.service

mysql-master-dump:
  cmd.run:
    - name: "mysqldump -u root --all-databases > /var/lib/mysql/dbdump.sql"
    - unless: test -f /var/lib/mysql/dbdump.sql
    - require_in:
      - sls: mysql.nfs.nfs_share_dump
      - sls: mysql.mysql_setup.service

mysql-master-unlock:
  cmd.run:
    - name: "mysql -e \"UNLOCK TABLES;\" "
    - require_in:
      - sls: mysql.nfs.nfs_share_dump
      - sls: mysql.mysql_setup.service

include:
    - mysql.mysql_setup.service
    - mysql.nfs.nfs_share_dump

share-socalled-dumpfile:
  cmd.run:
    - name: cp /var/lib/mysql/dbdump.sql /mnt/dbshareddir
    - require:
      - sls: mysql.mysql_setup.service
      - sls: mysql.nfs.nfs_share_dump
