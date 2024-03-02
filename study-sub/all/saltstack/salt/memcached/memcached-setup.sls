################## installation
update_apt_cache:
  pkg.uptodate:
    - refresh: True

install_memcached:
  pkg.installed:
    - name: memcached
    - unless: dpkg -l | grep -q "memcached"
    - require:
      - pkg: update_apt_cache

################## configuration

modify_memcached_config:
  file.managed:
    - name: /etc/memcached.conf
    - source: salt://memcached/configs/memcached.conf.jinja
    - template: jinja
    - require:
        - pkg: install_memcached

restart_memcached_service:
  service.running:
    - name: memcached
    - enable: True
    - enable_on_boot: True
    # - watch:
    #   - file: modify_memcached_config

