mysql-master-lock:
  cmd.run:
    - name: "mysql -e \"FLUSH TABLES WITH READ LOCK;\" "
    - require_in:
      - sls: mysql.nfs_share_dump
      - sls: mysql.service

mysql-master-dump:
  cmd.run:
    - name: "mysqldump -u root --all-databases > /var/lib/mysql/dbdump.sql"
    - unless: test -f /var/lib/mysql/dbdump.sql
    - require_in:
      - sls: mysql.nfs_share_dump
      - sls: mysql.service

mysql-master-unlock:
  cmd.run:
    - name: "mysql -e \"UNLOCK TABLES;\" "
    - require_in:
      - sls: mysql.nfs_share_dump
      - sls: mysql.service

include:
    - mysql.service
    - mysql.nfs_share_dump

share_socalled_dumpfile:
  cmd.run:
    - name: cp /var/lib/mysql/dbdump.sql /mnt/dbshareddir
    - require:
      - sls: mysql.service
      - sls: mysql.nfs_share_dump
