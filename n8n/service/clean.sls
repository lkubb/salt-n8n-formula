# vim: ft=sls


{#-
    Stops the n8n, db container services
    and disables them at boot time.
#}

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as n8n with context %}

n8n service is dead:
  compose.dead:
    - name: {{ n8n.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if n8n.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ n8n.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if n8n.install.rootless %}
    - user: {{ n8n.lookup.user.name }}
{%- endif %}

n8n service is disabled:
  compose.disabled:
    - name: {{ n8n.lookup.paths.compose }}
{%- for param in ["project_name", "container_prefix", "pod_prefix", "separator"] %}
{%-   if n8n.lookup.compose.get(param) is not none %}
    - {{ param }}: {{ n8n.lookup.compose[param] }}
{%-   endif %}
{%- endfor %}
{%- if n8n.install.rootless %}
    - user: {{ n8n.lookup.user.name }}
{%- endif %}
