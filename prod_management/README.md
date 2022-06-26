# Walgreens Health - Production Management Plane Resources

All resources that make up the production management plane are captured and maintained here

Incoming branches are validated for changes or additions to the `prod_management` folder that will be
deployed after merge to the main branch

> CHECK THESE VALIDATIONS CAREFULLY - THESE ARE PRODUCTION DEPLOYMENTS

You should validate configurations on replica resources in the non-production environment(s) first before
applying them to the production environment and closely evaluate staged changes to the production environment
to ensure you understand what is detected to change

All production resources should be detailed here with information about them and links to their definitions.


## Target Subscriptions
* wh-prod-management-01 _(Not reachable from this network directly)_
  * Subscription ID: `d042b16c-744c-4fba-a391-f8ab079d6cdf`


## Hub
* [Production vWAN](../prod_management_hub/wh-mgmt-prod-int-phub-eastus2.json) _(This file is excluded from standard evaluation)_
    * Resource ID: `/subscriptions/d042b16c-744c-4fba-a391-f8ab079d6cdf/resourceGroups/wh-mgmt-prod-int-phub-eastus2-rg/providers/Microsoft.Network/virtualWans/wh-mgmt-prod-int-phub-eastus2-vwan-01`
    * vHub
    * VpnGateway
    * Hub Firewall
      * Public IP: `23.101.150.27`
      * Private IP: `10.0.0.132`
    * Hub Firewall Policy
    * [Hub Firewall Policy Rules](./wh-mgmt-prod-int-phub-eastus2-vhub-01-fw-01-policy.json)
    > The policy rules will probably be split up into more consumable chunks


## Infrastructure Networking
* [Infrastructure VNET](./wh-mgmt-prod-int-infra-eastus2-vnet-01.json): The "Infra Zone" of the WH NP network
* [Infra 01 NSG](./wh-mgmt-prod-int-infra-eastus2-vnet-01-sn01-nsg.json)
* [Infra 01 Subnet](./wh-mgmt-prod-int-infra-eastus2-vnet-01-sn01.json): Delegated for running ADO build agents
* [Infra 02 NSG](./wh-mgmt-prod-int-infra-eastus2-vnet-01-sn02-nsg.json)
* [Infra 02 Subnet](./wh-mgmt-prod-int-infra-eastus2-vnet-01-sn02.json): Delegated for hosting containerized CCP services


## Central DNS
* [appserviceenvironment.net](./dns_zones/appserviceenvironment.net.json)


## Central Logging
* [Production Security Workspace](./prod-infra-seclaws-eastus2-01.json)
* [Production General Infra Workspace](./prod-infra-laws-eastus2-01.json)
* [Production Subscription Audit Registration](./prod-laws-subscription-datasources.json)


## Provisioning
* [Provisioning Identity](./prod-infra-provisioning-agents-id-01.json)
  * ResourceID: `/subscriptions/d042b16c-744c-4fba-a391-f8ab079d6cdf/resourceGroups/prod-infra-provisioning-agents-eastus2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/prod-infra-provisioning-agents-id-01`
  * Object ID: `74942ba3-129a-4d1d-9321-f13a020dc6fc`
  * Client ID: `3d7aafde-b75e-425f-8b50-b35a78a1cca5`
* [Provisioning Agents Keyvault](./p-inf-prv-agents-kv-01.json)
* [Provisioning Agents Registry](./prodinfraprvagentsacr01.json)
* [Provisioning Agent Container 01](./prod-infra-provisioning-agents-aci-01.json)
* [Provisioning Agent Container 02](./prod-infra-provisioning-agents-aci-02.json)
* [Provisioning Agent Container 03](./prod-infra-provisioning-agents-aci-03.json)

> When making changes to the provisioning agent containers it is recommended to mark them disabled in the agent pool
> so they do not get scheduled to perform the job that will update them _(it won't go well for you)_.
>
> you can do this in two waves generally taking one out of the pool and updating it, and then using it to update the rest


## Infra Services
* [Infra Services ASE](./rpu-prod-infra-services-eastus2-ase-01.json)
  * IP Address: `10.0.1.36`
* Hub Peering API:
  * [Peering API ASP](./ccp-peering-api-p-l-asp-01.json)
  * [Peering API Site](./ccp-peering-api.json)
    * Object ID: `a5ad374e-2eee-49e7-875d-54b54748f3fd`
    * URL: `https://ccp-peering-api.rpu-prod-infra-svcs-eastus2-ase-01.appserviceenvironment.net`


## Tags
Tags are applied to each subscription based on their classification _(parent management group)_

Builtin "Inherit a tag from the subscription" policies are assigned at the "Walgreens Health - Prod" scope for each of the billing tags
_(SubscriptionEnvironment & SubscriptionGroupArea are not cascaded)_

```js
/subscriptions/d042b16c-744c-4fba-a391-f8ab079d6cdf
{
    "CostCenter": "Healthcare Development 5004",
    "CostCode": "1000609920",
    "Department": "Innovation H3",
    "LegalSubEntity": "Walgreen Co",
    "SubDivision": "Innovation H3",
    "SubscriptionEnvironment": "Infrastructure",
    "SubscriptionGroupArea": "WalgreensHealth"
}
```

### Infrastructure
```ps
@{"CostCenter"="Healthcare Development 5004";"CostCode"="1000609920";"Department"="Innovation H3";"LegalSubEntity"="Walgreen Co";"SubDivision"="Innovation H3";"SubscriptionEnvironment"="Infrastructure";"SubscriptionGroupArea"="WalgreensHealth"}
```

### Production
```ps
@{"CostCenter"="Healthcare Development 5004";"CostCode"="1000609920";"Department"="Innovation H3";"LegalSubEntity"="Walgreen Co";"SubDivision"="Innovation H3";"SubscriptionEnvironment"="Production";"SubscriptionGroupArea"="WalgreensHealth"}
```

### Non-Production
```ps
@{"CostCenter"="Healthcare Development 5004";"CostCode"="1000609920";"Department"="Innovation H3";"LegalSubEntity"="Walgreen Co";"SubDivision"="Innovation H3";"SubscriptionEnvironment"="Non-Production";"SubscriptionGroupArea"="WalgreensHealth"}
```
