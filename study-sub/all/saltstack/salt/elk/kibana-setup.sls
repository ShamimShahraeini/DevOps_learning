################## installation

import_gpg_key:
  cmd.run:
    - name: wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor | tee /usr/share/keyrings/elasticsearch-keyring.gpg
    - unless: test -f /usr/share/keyrings/elasticsearch-keyring.gpg

install_kibana_dependencies:
  pkg.installed:
    - name: apt-transport-https
    - unless: dpkg -l | grep -q "apt-transport-https"
    - require:
      - cmd: import_gpg_key

add_repo:
  file.append:
    - name: /etc/apt/sources.list.d/elastic-8.list
    - text: "deb [signed-by=/usr/share/keyrings/elasticsearch-keyring.gpg] https://artifacts.elastic.co/packages/8.x/apt stable main"
    - unless: grep -q "elastic-8.list" /etc/apt/sources.list.d/*
    - require:
      - cmd: import_gpg_key

update_apt_cache:
  pkg.uptodate:
    - refresh: True
    - require:
      - file: add_repo

install_kibana:
  pkg.installed:
    - name: kibana
    - unless: dpkg -l | grep -q "kibana"
    - require:
      - pkg: update_apt_cache

################## configuration

modify_kibana_config:
  file.managed:
    - name: /etc/kibana/kibana.yml
    - source: salt://elk/configs/kibana.yml.jinja
    - template: jinja
    - require:
        - pkg: install_kibana

restart_kibana_service:
  service.running:
    - name: kibana
    - enable: True
    - enable_on_boot: True
    - watch:
      - file: modify_kibana_config

