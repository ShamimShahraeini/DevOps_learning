 {% set minion_id = salt['grains.get']('host') %}

 {% if minion_id %}
 cmd.run:
  salt.function:
    - tgt: '*'
    - arg:
      - hostname

 minion_add:
   salt.wheel:
     - name: key.accept
     - match: {{ minion_id }}

 pause_flow:
   salt.runner:
     - name: test.sleep
     - s_time: 5
     - require:
       - salt: minion_add

 deploy_highstate:
   salt.state:
     - tgt: {{ minion_id }}
     - highstate: True
     - require:
         - salt: minion_add

 {% else %}
 need_minion:
   test.fail_without_changes:
     - name: The required 'minion_id' value
 {% endif %}