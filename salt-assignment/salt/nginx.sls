---
nginx_pkg:
  pkg.installed:
    - name: nginx
nginx_conf:
  file.managed:
    - name: /etc/nginx/conf.d/default.conf
    - source: salt://nginx/nginx_default.conf  # Custom Nginx config
    - user: root
    - group: root
    - mode: '644'
    - require:
        # Requisite argument list item (8 spaces for indentation)
        - pkg: nginx_pkg
    - watch_in:
        # Execution controller argument list item (8 spaces for indentation)
        - service: nginx_service
nginx_default_site_absent:
  file.absent:
    - name: /etc/nginx/sites-enabled/default
    - require:
      - pkg: nginx_pkg
    - watch_in:
      - service: nginx_service
nginx_index:
  file.managed:
    - name: /usr/share/nginx/html/index.html
    - source: salt://nginx/index.html.jinja  # Jinja template for index.html
    - template: jinja
    - require:
        # Requisite argument list item (8 spaces for indentation)
        - pkg: nginx_pkg
    - watch_in:
        # Execution controller argument list item (8 spaces for indentation)
        - service: nginx_service
nginx_service:
  service.running:
    - name: nginx
    - enable: true
