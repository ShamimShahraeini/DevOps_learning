mysql-service:
  service.running:
    - name: mysql
    - restart: True
    - enable: True
    - reload: True
