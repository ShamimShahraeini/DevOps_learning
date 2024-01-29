{% set CONTAINER_NAME = 'mysql' %}
{% set BASE_PATH = '/var/lib/machines/' %}
#{% set FULL_CONTAINER_NAME = "{{ salt['grains.get']('host') }}-{{ CONTAINER_NAME }}" %}
#{% set FULL_PATH = '{{ BASE_PATH }}{{ CONTAINER_NAME }}' %}
## TODO: 'clean code' rules


include:
  - containers.container-setup
  #- containers.network-setup
  - containers.container-salt-minion
