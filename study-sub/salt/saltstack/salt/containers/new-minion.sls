{% set minion_id = salt['grains.get']('host') if 'master' in salt['grains.get']('host') else None %}

 {% if minion_id %}
 delete_pki_for_renew:
  cmd.run:
    - name: rm /etc/salt/pki/master/minions/*-mysql.pub

 minion_add:
   cmd.run:
     - name: salt-key -A -y

 pause_flow:
   salt.runner:
     - name: test.sleep
     - s_time: 5
     - require:
       - salt: minion_add

 {% else %}
 need_minion:
   test.fail_without_changes:
     - name: The required 'minion_id' value
 {% endif %}