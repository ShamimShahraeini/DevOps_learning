memcached-container_setup:
  salt.state:
    - tgt: 'minion[1,2,3]'
    - sls:
      - containers.init
    - unless: machinectl | grep memcached  || machinectl | grep mcrouter
# TODO: target minions more reusable

{% for node, attr in salt.pillar.get('containers', []).items() %}
{% if attr.role == 'memcached-node' %}
memcached_setup_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - memcached.memcached-setup
{% elif attr.role == 'mcrouter-node' %}
mcrouter_setup_{{ node }}:
  salt.state:
    - tgt: '{{ attr.host }}'
    - sls:
      - memcached.mcrouter-setup
{% endif%}
{% endfor %}
