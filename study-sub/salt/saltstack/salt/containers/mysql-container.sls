{% set CONTAINER_NAME = 'mysql' %}
{% set BASE_PATH = '/var/lib/machines/' %}
#{% set FULL_CONTAINER_NAME = "{{ salt['grains.get']('host') }}-{{ CONTAINER_NAME }}" %}
#{% set FULL_PATH = '{{ BASE_PATH }}{{ CONTAINER_NAME }}' %}
## TODO: 'clean code' rules


include:
  - containers.container-setup
  - containers.container-salt-minion


##test
# container_apt_update:
#   cmd.run:
#     - name: apt update
#     - tgt: 'L@*-{{ CONTAINER_NAME }}'
#     - require:
#       - pkg: system_packages


############################ app in container setup: mysql

# configure-mysql:
#   state.sls:
#     - tgt: 'L@{{ CONTAINER_NAME }}'
#     - sls: mysql
