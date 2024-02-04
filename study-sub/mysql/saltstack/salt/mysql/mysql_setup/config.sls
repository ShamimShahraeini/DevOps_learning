mysql_config:
  file.managed:
    - name: /etc/mysql/my.cnf
    - source: salt://mysql/mysql_setup/configs/my.cnf
    - template: jinja
    - require:
        - cmd: install_percona
