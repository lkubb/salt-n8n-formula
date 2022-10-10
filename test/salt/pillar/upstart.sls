# -*- coding: utf-8 -*-
# vim: ft=yaml
---
n8n:
  lookup:
    master: template-master
    # Just for testing purposes
    winner: lookup
    added_in_lookup: lookup_value
    compose:
      create_pod: null
      pod_args: null
      project_name: n8n
      remove_orphans: true
      build: false
      build_args: null
      pull: false
      service:
        container_prefix: null
        ephemeral: true
        pod_prefix: null
        restart_policy: on-failure
        restart_sec: 2
        separator: null
        stop_timeout: null
    paths:
      base: /opt/containers/n8n
      compose: docker-compose.yml
      config_n8n: n8n.env
      config_db: db.env
      data: data
      db: db
    user:
      groups: []
      home: null
      name: n8n
      shell: /usr/sbin/nologin
      uid: null
      gid: null
    containers:
      db:
        image: docker.io/library/mariadb
      n8n:
        image: docker.io/n8nio/n8n:latest
      redis:
        image: docker.io/library/redis:latest
  install:
    rootless: true
    autoupdate: true
    autoupdate_service: false
    remove_all_data_for_sure: false
  config:
    db:
      mysqldb:
        database: n8n
        host: db
        password: null
        port: 3306
        user: n8n
      postgresdb:
        database: n8n
        host: db
        password: null
        port: 5432
        user: n8n
      type: sqlite
    generic_timezone: Etc/UTC
    n8n:
      diagnostics:
        enabled: false
      port: 5678
    queue:
      bull_redis_host: redis
  mysql:
    enable: false
  redis:
    enable: false
  postgres:
    enable: false

  tofs:
    # The files_switch key serves as a selector for alternative
    # directories under the formula files directory. See TOFS pattern
    # doc for more info.
    # Note: Any value not evaluated by `config.get` will be used literally.
    # This can be used to set custom paths, as many levels deep as required.
    files_switch:
      - any/path/can/be/used/here
      - id
      - roles
      - osfinger
      - os
      - os_family
    # All aspects of path/file resolution are customisable using the options below.
    # This is unnecessary in most cases; there are sensible defaults.
    # Default path: salt://< path_prefix >/< dirs.files >/< dirs.default >
    #         I.e.: salt://n8n/files/default
    # path_prefix: template_alt
    # dirs:
    #   files: files_alt
    #   default: default_alt
    # The entries under `source_files` are prepended to the default source files
    # given for the state
    # source_files:
    #   n8n-config-file-file-managed:
    #     - 'example_alt.tmpl'
    #     - 'example_alt.tmpl.jinja'

    # For testing purposes
    source_files:
      n8n environment file is managed:
      - n8n.env.j2

  # Just for testing purposes
  winner: pillar
  added_in_pillar: pillar_value
