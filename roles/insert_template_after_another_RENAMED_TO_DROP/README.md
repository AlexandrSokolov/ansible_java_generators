Usage:

```
- name: "Add a dependency on 'commons_config' into the 'domain' module"
  include_role:
    name: insert_template_after_another
  with_items:
    - path: "{{ mvn_project_basedir }}/domain/pom.xml"
      insert_after_template: "{{ role_path }}/templates/domain/insert_after_template.j2"
      insert_template: "{{ role_path }}/templates/domain/insert_template.j2"
```