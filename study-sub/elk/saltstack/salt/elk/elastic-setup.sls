################## installation

install_java:
  pkg.installed:
    - name: default-jre

import_elasticsearch_gpg_key:
  cmd.run:
    - name: wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor | tee /usr/share/keyrings/elasticsearch-keyring.gpg
    - unless: test -f /usr/share/keyrings/elasticsearch-keyring.gpg
    - require:
      - pkg: install_java

add_elasticsearch_repo:
  file.append:
    - name: /etc/apt/sources.list.d/elastic-8.list
    - text: "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main"
    - unless: grep -q "elastic-8.list" /etc/apt/sources.list.d/*
    - require:
      - cmd: import_elasticsearch_gpg_key

update_apt_cache:
  pkg.uptodate:
    - refresh: True
    - require:
      - file: add_elasticsearch_repo

install_elasticsearch:
  pkg.installed:
    - name: elasticsearch
    - unless: dpkg -l | grep -q "elasticsearch"
    - require:
      - pkg: update_apt_cache

install_curl:
  pkg.installed:
    - name: curl
    - unless: dpkg -l | grep -q "curl"
    - require:
      - pkg: update_apt_cache

################## configuration

modify_elasticsearch_config:
  file.managed:
    - name: /etc/elasticsearch/elasticsearch.yml
    - source: salt://elk/configs/elasticsearch1.yml.jinja
    - template: jinja
    - require:
        - pkg: install_elasticsearch
    # - name: /etc/elasticsearch/elasticsearch.yml
    # - pattern: 'cluster.initial_master_nodes: \["\?"\]'
    # - repl: 'cluster.initial_master_nodes: ["{{ grains['fqdn'] }}"]'

tune_heap_size:
  cmd.run:
    - name: echo "vm.max_map_count=262144" >> /etc/sysctl.conf

restart_elasticsearch_service:
  service.running:
    - name: elasticsearch
    - enable: True
    - enable_on_boot: True
    - watch:
      - file: modify_elasticsearch_config

