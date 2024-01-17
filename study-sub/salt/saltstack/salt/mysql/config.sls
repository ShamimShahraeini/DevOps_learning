mysql-config:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mysql/my.cnf
    - template: jinja
