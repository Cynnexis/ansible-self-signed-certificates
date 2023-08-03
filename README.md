## Ansible Self-Signed Certificates Role

This role generate a self-signed CA, server and client certificates.

## Requirements

- Ansible 2.1 or newer.
- Python dependency `cryptography>=37.0.2`
- Python dependency `passlib[bcrypt]`

You can install them using `pip install -r requirements.txt`

## Role Variables

You can see the role variables in [`defaults/main.yml`](https://github.com/Cynnexis/ansible-self-signed-certificates/blob/main/defaults/main.yml):

```yaml
# General information
self_signed_certs_dir: /usr/share/ca-certificates/my-certificates
self_signed_owner: root
self_signed_group: root
self_signed_mode: '644'
self_signed_verify: true

# Information about the maintainer of the certificates
self_signed_default_common_name: ''
self_signed_default_email_address: ''
self_signed_default_country_name: ''
self_signed_default_state_or_province_name: ''
self_signed_default_locality_name: ''
self_signed_default_organization_name: ''
self_signed_default_organizational_unit_name: ''
self_signed_default_cert_validity: +3650d # 10 years
self_signed_default_private_key_type: ''
self_signed_default_private_key_size: 0

# CA configuration
self_signed_ca_common_name: ''
self_signed_ca_email_address: ''
self_signed_ca_country_name: ''
self_signed_ca_state_or_province_name: ''
self_signed_ca_locality_name: ''
self_signed_ca_organization_name: ''
self_signed_ca_organizational_unit_name: ''
self_signed_ca_cert_validity: +3650d # 10 years
self_signed_ca_owner: ''
self_signed_ca_group: ''
self_signed_ca_mode: '664'
self_signed_ca_private_key_type: ''
self_signed_ca_private_key_size: 0
self_signed_ca_subject_alt_name:
  - 'DNS:example.com'
  - 'DNS:*.example.com'

# Server/client configuration
self_signed_certificates:
  - name: 'example'
    common_name: ''
    email_address: ''
    country_name: ''
    state_or_province_name: ''
    locality_name: ''
    organization_name: ''
    organizational_unit_name: ''
    cert_validity: +3650d # 10 years
    owner: ''
    group: ''
    mode: 0
    private_key_type: ''
    private_key_size: 0
    subject_alt_name:
      - 'DNS:example.com'
      - 'DNS:*.example.com'
```

## Dependencies

- [`buluma.bootstrap`](https://galaxy.ansible.com/buluma/bootstrap)
- [`buluma.python_pip`](https://galaxy.ansible.com/buluma/python_pip)

You can install them using `ansible-galaxy collection install -r requirements.yml`

## Example Playbook

In your `requirements.yml`:

```yaml
---
roles:
  # Generate CA certificate, server and client certificates
  # Documentation: https://github.com/Cynnexis/ansible-self-signed-certificates
  - name: ansible-self-signed-certificates
    src: ssh://git@github.com/Cynnexis/ansible-self-signed-certificates
    version: main
    scm: git
```

In your playbook:

```yaml
- hosts: all
  become: true
  gather_facts: false
  tasks:

    - name: Install Python dependencies
      pip:
        name:
          - cryptography>=37.0.2

    - include_role: ansible-self-signed-certificates
      vars:
        # General information
        self_signed_certs_dir: /usr/share/ca-certificates/my-certificates
        self_signed_owner: root
        self_signed_group: root
        self_signed_mode: '644'
        self_signed_verify: true

        # Information about the maintainer of the certificates
        self_signed_default_common_name: example.com
        self_signed_default_email_address: john.doe@example.com
        self_signed_default_country_name: Country
        self_signed_default_state_or_province_name: State
        self_signed_default_locality_name: Locality
        self_signed_default_organization_name: Organization
        self_signed_default_organizational_unit_name: Unit
        self_signed_default_cert_validity: +365d # 1 years

        # CA configuration
        self_signed_ca_subject_alt_name:
          - DNS:example.com
          - DNS:*.example.com

        # Server/client configuration
        self_signed_certificates:

          - name: 'example1'
            subject_alt_name:
              - DNS:example1.com
              - DNS:*.example1.com

          - name: 'example2'
            subject_alt_name:
              - DNS:example2.com
              - DNS:*.example2.com
```

This will generate the following directory:

```plain
/usr/share/ca-certificates/my-certificates
├── ca.crt
├── ca.csr
├── ca.key
├── ca.pem
├── example1
│   ├── client.crt
│   ├── client.csr
│   ├── client.key
│   ├── client.pem
│   ├── server.crt
│   ├── server.csr
│   ├── server.key
│   └── server.pem
└── example2
    ├── client.crt
    ├── client.csr
    ├── client.key
    ├── client.pem
    ├── server.crt
    ├── server.csr
    ├── server.key
    └── server.pem
```

## Tests

This role can be tested using Ansible Molecule:

```bash
pip install -r requirements.txt
molecule test
```

# License

[MIT](LICENSE)

# Author Information

- [Valentin Berger](https://github.com/Cynnexis)
