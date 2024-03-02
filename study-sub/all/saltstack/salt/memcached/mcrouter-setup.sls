################## installation

install_mcrouter_dependencies:
  cmd.run:
    - name: apt-get update && apt-get -y install sudo wget gnupg2 autoconf

import_mcrouter_gpg_key:
  cmd.run:
    - name: sudo wget -O - https://facebook.github.io/mcrouter/debrepo/bionic/PUBLIC.KEY |  apt-key add -

add_mcrouter_repo:
  file.append:
    - name: /etc/apt/sources.list.d/mcrouter.list
    - text: "deb https://facebook.github.io/mcrouter/debrepo/bionic bionic contrib"
    - unless: grep -q "mcrouter.list" /etc/apt/sources.list.d/*
    - require:
      - cmd: import_mcrouter_gpg_key

update_apt_cache:
  pkg.uptodate:
    - refresh: True

install_mcrouter:
  pkg.installed:
    - name: mcrouter
    - unless: dpkg -l | grep -q "mcrouter"
    - require:
      - pkg: update_apt_cache

################## configuration

modify_mcrouter_config:
  file.managed:
    - name: /etc/mcrouter/mcrouter.conf
    - source: salt://memcached/configs/mcrouter.conf.jinja
    - template: jinja
    - require:
        - pkg: install_mcrouter

restart_mcrouter_service:
  service.running:
    - name: mcrouter
    - enable: True
    - enable_on_boot: True
    # - watch:
    #   - file: modify_memcached_config

