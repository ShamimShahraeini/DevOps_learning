mysql_config:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mysql/configs/my.cnf
    - template: jinja
    - require:
        - cmd: install_percona
