# LDAP Integration

LDAP integration is controlled by a LDAP.yml file which will be located in the /HEIMDALLDIR/config folder. There should be a file called ldap.example.yml, go ahead and copy this and rename it to ldap.yml.

## Example of ldap.example.yml

```
# You can also just copy and paste the tree (do not include the "authorizations") to each
# environment if you need something different per environment.
authorizations: &AUTHORIZATIONS
  allow_unauthenticated_bind: false
  group_base: ou=groups,dc=test,dc=com
  ## Requires config.ldap_check_group_membership in devise.rb be true
  # Can have multiple values, must match all to be authorized
  required_groups:
    # If only a group name is given, membership will be checked against "uniqueMember"
    - cn=admins,ou=groups,dc=test,dc=com
    - cn=users,ou=groups,dc=test,dc=com
    # If an array is given, the first element will be the attribute to check against, the second the group name
    - ["moreMembers", "cn=users,ou=groups,dc=test,dc=com"]
  ## Requires config.ldap_check_attributes in devise.rb to be true
  ## Can have multiple attributes and values, must match all to be authorized
  require_attribute:
    objectClass: inetOrgPerson
    authorizationRole: postsAdmin
  ## Requires config.ldap_check_attributes_presence in devise.rb to be true
  ## Can have multiple attributes set to true or false to check presence, all must match all to be authorized
  require_attribute_presence:
    mail: true
    telephoneNumber: true
    serviceAccount: false

## Environment

development:
  host: host.yourdomain.com
  port: 636
  attribute: mail
  base: ou=People,o=yourdomain.com
  admin_user: cn=admin,dc=test,dc=com
  admin_password: "credentials"
  ssl: true
  # <<: *AUTHORIZATIONS

test:
  host: localhost
  port: 3389
  attribute: cn
  base: ou=people,dc=test,dc=com
  admin_user: cn=admin,dc=test,dc=com
  admin_password: "credentials"
  ssl: simple_tls
  # <<: *AUTHORIZATIONS

production:
  host: host.yourdomain.com
  port: 636
  attribute: mail
  base: ou=People,o=yourdomain.com
  admin_user: cn=admin,dc=test,dc=com
  admin_password: "credentials"
  ssl: true
  # <<: *AUTHORIZATIONS
```

Depending what environment you're running, you can configure a different LDAP server for each one, such as testing, production and development. If you're unsure of what to use, you will most likely be using production. 

These values will need to be changed to reflect the LDAP server you are connecting to. Your LDAP admin or IT specialist should be able to provide you with the necessary information.

## Devise.rb Configuration

This file is located at /heimdall/config/initializers/devise.rb

The following values are set in the devise.rb and their options are laid out below. 

* ldap_logger (default: true)
  * If set to true, will log LDAP queries to the Rails logger.
* ldap_create_user (default: false)
  * If set to true, all valid LDAP users will be allowed to login and an appropriate user record will be created. If set to false, you will have to create the user record before they will be allowed to login.
* ldap_config (default: #{Rails.root}/config/ldap.yml)
  * Where to find the LDAP config file. Commented out to use the default, change if needed.
* ldap_update_password (default: true)
  * When doing password resets, if true will update the LDAP server. Requires admin password in the ldap.yml
* ldap_check_group_membership (default: false)
  * When set to true, the user trying to login will be checked to make sure they are in all of groups specified in the ldap.yml file.
* ldap_check_attributes (default: false)
  * When set to true, the user trying to login will be checked to make sure their attributes match those specified in the ldap.yml file.
* ldap_check_attributes_presence (default: false)
  * When set to true, the user trying to login will be checked against all require_attribute_presence attributes in the ldap.yml file, either present (attr: true),or not present (attr: false).
* ldap_use_admin_to_bind (default: false)
  * When set to true, the admin user will be used to bind to the LDAP server during authentication.
* ldap_check_group_membership_without_admin (default: false)
  * When set to true, the group membership check is done with the user's own credentials rather than with admin credentials. Since these credentials are only available to the Devise user model during the login flow, the group check function will not work if a group check is performed when this option is true outside of the login flow (e.g., before particular actions).

