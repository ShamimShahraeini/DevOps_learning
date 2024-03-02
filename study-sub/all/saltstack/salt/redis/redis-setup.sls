################## installation

import_gpg_key:
  cmd.run:
    - name: curl -fsSL https://packages.redis.io/gpg | sudo gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg
    - unless: test -f /usr/share/keyrings/redis-archive-keyring.gpg

install_redis_dependencies:
  pkg.installed:
    - name: 
      - software-properties-common 
      - apt-transport-https 
      - curl 
      - ca-certificates

add_repo:
  file.append:
    - name: /etc/apt/sources.list.d/redis.list
    - text: "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb stable main"
    - unless: grep -q "redis.list" /etc/apt/sources.list.d/*
    - require:
      - cmd: import_gpg_key

update_apt_cache:
  pkg.uptodate:
    - refresh: True
    - require:
      - file: add_repo

install_redis:
  pkg.installed:
    - name: 
      - redis 
      - redis-server 
      - redis-tools
    - unless: dpkg -l | grep -q "redis"
    - require:
      - pkg: update_apt_cache

################## configuration

# modify_redis_config:
#   file.managed:
#     - name: /etc/redis/redis.yml
#     - source: salt://elk/configs/redis.yml.jinja
#     - template: jinja
#     - require:
#         - pkg: install_redis

# restart_redis_service:
#   service.running:
#     - name: redis
#     - enable: True
#     - enable_on_boot: True
#     - watch:
#       - file: modify_redis_config

