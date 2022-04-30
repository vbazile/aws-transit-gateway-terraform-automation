# VPC Infra

This stack creates the VPC for a given environment.<br>

> WARNING:
> - Make sure to always initialize the backend (terraform init) with the right backend.cfg to ascertain you work on the correct tfstate
----
<br>

To avoid code repetition, there is a variabilized base of .tf files, that you instanciate by providing:
- a backend config
- a .tfvars file with the configured variables

For instance, if you'd like to launch a VPC in the si-interne account, you would need to:
- change directory in Stacks/Plateforme/vpc-infra/ressources
- initialize the si-interne backend with **terraform init -reconfigure -backend-config=../var/si-interne-test/backend.cfg**
- apply the configuration code with the following line: **terraform apply --var "profile=tooling" --var-file=../var/si-interne-test/values.tfvars**

To destroy the VPC:
- change directory in Stacks/Plateforme/vpc-infra/ressources
- initialize the si-interne backend with **terraform init -reconfigure -backend-config=../var/si-interne-test/backend.cfg**
- destroy the vpc with the following line: **terraform apply --var "profile=tooling" --var-file=../var/si-interne-test/values.tfvars**

## To create a new VPC for a new environment
- in the /var directory, duplicate a folder (e.g., /si-interne-test)
- rename the /si-interne-test folder (e.g. for prod, /si-interne-test -> /si-interne-prod)
- in **backend.cfg**, change the key so it reflects the given environment
- in **values.tfvars**, change the values so they are relevant with the given environment
- change directory in Stacks/Plateforme/vpc-infra/ressources
- initialize the backend with **terraform init -reconfigure -backend-config=../var/si-interne-prod/backend.cfg**
- apply the configuration code with the following line: **terraform apply --var "profile=tooling" --var-file=../var/si-interne-prod/values.tfvars**