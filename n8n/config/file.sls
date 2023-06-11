# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- set sls_package_install = tplroot ~ ".package.install" %}
{%- from tplroot ~ "/map.jinja" import mapdata as n8n with context %}
{%- from tplroot ~ "/libtofsstack.jinja" import files_switch with context %}

include:
  - {{ sls_package_install }}

n8n environment files are managed:
  file.managed:
    - names:
      - {{ n8n.lookup.paths.config_n8n }}:
        - source: {{ files_switch(
                        ["n8n.env", "n8n.env.j2"],
                        config=n8n,
                        lookup="n8n environment file is managed",
                        indent_width=10,
                     )
                  }}
      - {{ n8n.lookup.paths.config_db }}:
        - source: {{ files_switch(
                        ["db.env", "db.env.j2"],
                        config=n8n,
                        lookup="db environment file is managed",
                        indent_width=10,
                     )
                  }}
    - mode: '0640'
    - user: root
    - group: {{ n8n.lookup.user.name }}
    - makedirs: true
    - template: jinja
    - require:
      - user: {{ n8n.lookup.user.name }}
    - watch_in:
      - n8n is installed
    - context:
        n8n: {{ n8n | json }}
