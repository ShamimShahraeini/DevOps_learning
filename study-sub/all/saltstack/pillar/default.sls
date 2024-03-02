# Default pillar values

servers:
  master:
    ip: 192.168.56.10
  minion1:
    ip: 192.168.56.11
    container_name: mysql
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/mysql
    # port:
  minion2:
    ip: 192.168.56.12
    container_name: mysql
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/mysql
    # port:
  minion3:
    ip: 192.168.56.13
    container_name: mysql
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/mysql
    # port:

include:
  - redis

servers:
  master:
    ip: 192.168.56.10
  minion1:
    ip: 192.168.56.11
    container_name: elastic
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/elastic
    # port:
  minion2:
    ip: 192.168.56.12
    container_name: elastic
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/elastic
    # port:
  minion3:
    ip: 192.168.56.13
    container_name: elastic
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/elastic
    # port:

include:
  - elk

servers:
  master:
    ip: 192.168.56.10
  minion1:
    ip: 192.168.56.11
    container_name: memcached
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/memcached
    # port:
  minion2:
    ip: 192.168.56.12
    container_name: memcached
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/memcached
    # port:
  minion3:
    ip: 192.168.56.13
    container_name: mcrouter
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/mcrouter
    # port:

include:
  - memcached

servers:
  master:
    ip: 192.168.56.10
  minion1:
    ip: 192.168.56.11
    container_name: redis
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/redis
    # port:
  minion2:
    ip: 192.168.56.12
    container_name: redis
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/redis
    # port:
  minion3:
    ip: 192.168.56.13
    container_name: redis
    container_base_path: /var/lib/machines/
    bind_path: /var/lib/redis
    # port:

include:
  - redis

