# Default pillar values
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