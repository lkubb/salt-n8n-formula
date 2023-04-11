# vim: ft=sls

{%- set tplroot = tpldir.split("/")[0] %}
{%- from tplroot ~ "/map.jinja" import mapdata as n8n with context %}
{%- from tplroot ~ "/libtofs.jinja" import files_switch with context %}

n8n user account is present:
  user.present:
{%- for param, val in n8n.lookup.user.items() %}
{%-   if val is not none and param != "groups" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - usergroup: true
    - createhome: true
    - groups: {{ n8n.lookup.user.groups | json }}
    # (on Debian 11) subuid/subgid are only added automatically for non-system users
    - system: false

n8n user session is initialized at boot:
  compose.lingering_managed:
    - name: {{ n8n.lookup.user.name }}
    - enable: {{ n8n.install.rootless }}
    - require:
      - user: {{ n8n.lookup.user.name }}

n8n paths are present:
  file.directory:
    - names:
      - {{ n8n.lookup.paths.base }}
    - user: {{ n8n.lookup.user.name }}
    - group: {{ n8n.lookup.user.name }}
    - makedirs: true
    - require:
      - user: {{ n8n.lookup.user.name }}

{%- if n8n.install.podman_api %}

n8n podman API is enabled:
  compose.systemd_service_enabled:
    - name: podman.socket
    - user: {{ n8n.lookup.user.name }}
    - require:
      - n8n user session is initialized at boot

n8n podman API is available:
  compose.systemd_service_running:
    - name: podman.socket
    - user: {{ n8n.lookup.user.name }}
    - require:
      - n8n user session is initialized at boot
{%- endif %}

n8n compose file is managed:
  file.managed:
    - name: {{ n8n.lookup.paths.compose }}
    - source: {{ files_switch(["docker-compose.yml", "docker-compose.yml.j2"],
                              lookup="n8n compose file is present"
                 )
              }}
    - mode: '0644'
    - user: root
    - group: {{ n8n.lookup.rootgroup }}
    - makedirs: True
    - template: jinja
    - makedirs: true
    - context:
        n8n: {{ n8n | json }}

n8n is installed:
  compose.installed:
    - name: {{ n8n.lookup.paths.compose }}
{%- for param, val in n8n.lookup.compose.items() %}
{%-   if val is not none and param != "service" %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
{%- for param, val in n8n.lookup.compose.service.items() %}
{%-   if val is not none %}
    - {{ param }}: {{ val }}
{%-   endif %}
{%- endfor %}
    - watch:
      - file: {{ n8n.lookup.paths.compose }}
{%- if n8n.install.rootless %}
    - user: {{ n8n.lookup.user.name }}
    - require:
      - user: {{ n8n.lookup.user.name }}
{%- endif %}

{%- if n8n.install.autoupdate_service is not none %}

Podman autoupdate service is managed for n8n:
{%-   if n8n.install.rootless %}
  compose.systemd_service_{{ "enabled" if n8n.install.autoupdate_service else "disabled" }}:
    - user: {{ n8n.lookup.user.name }}
{%-   else %}
  service.{{ "enabled" if n8n.install.autoupdate_service else "disabled" }}:
{%-   endif %}
    - name: podman-auto-update.timer
{%- endif %}
