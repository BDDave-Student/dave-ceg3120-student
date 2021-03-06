## Kanban Board
https://github.com/BDDave-Student/dave-ceg3120-student/projects/1

## Service Set-up
- Barebones Private Git Server: https://www.andrewhoog.com/post/howto-setup-a-private-git-server-on-ubuntu-18.04/
- Open-LDAP: https://www.techrepublic.com/article/how-to-install-openldap-on-ubuntu-18-04/

## Today

## 29/10/2020
- dpkg config:
  - DNS:  bdd-ldap-dn
  - Org:  bdd-ldap-org
  - Password:  [hint: it's generic]
  - Backend:  MDB
  - /var/lib/ldap
- slapd ldap-utils: admin
- Configuration of ldap_data.ldif needed.  
![ldap-utils](images/project2-ldap-utils.PNG)

## 28/10/2020
- Moved Git Server to new Instance+IP (52.2.81.181)
- Reconfigured hostname to meaningful convention
- Created local key pair and added public key to git server
- Tested git repository to local machine:  
![git-server-README](images/project2-git-server-README.PNG)
![git-local-clone](images/project2-git-local-clone.PNG)
![git-local-pull](images/project2-git-local-pull.PNG)

## 26/10/2020
- Installed barebones git server to AWS machine
- Configured INBOUND port 9418 for GitHub, 389 and 636 for OpenLAPD

## 17/10/2020
- Attached IP to SLAPD instance
![SLAPD-IP](images/project2-slapd-ip.PNG)
- Attached IP to GitHub instance
![GitHub-IP](images/project2-github-ip.PNG)
- Configured Instance settings and launched 2 instances for GitLab and SLAPD
![Instances](images/project2-instances.PNG)
- Created VPC on AWS
![VPC](images/project2-VPC.PNG)
