redis-container_setup:
  salt.state:
    - tgt: 'minion[1,2,3]'
    - sls:
      - containers.init
    - unless: machinectl | grep redis
## TODO: target minions more reusable

{% for node, attr in salt.pillar.get('containers', []).items() %}

redis_setup_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - elk.redis-setup

{% endfor %}
