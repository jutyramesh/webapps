# Walgreens Health - Non-Production Management Plane Resources

All resources that make up the non-production management plane are captured and maintained here

Incoming branches are validated for changes or additions to the `nprod_management` folder that will be
deployed after merge to the main branch

> CHECK THESE VALIDATIONS CAREFULLY - THESE ARE CONSIDERED PRODUCTION DEPLOYMENTS
>
> Several of these resources service the health and operability of the non-production
> environments with hundreds of developers operating nearly around the clock.
> While this is not a "production" environment, disruption to functionality of
> core infrastructure is still likely to cause major impact to application team
> productivity and treated as a major outage

You should validate configurations on replica resources in a non-impactful environment(s) first before
applying them to the non-production management environment and closely evaluate staged changes to the non-production environment
to ensure you understand what is detected to change

All non-production management resources should be detailed here with information about them and links to their definitions.


## Target Subscriptions
* [wh-nprod-management-01](https://portal.azure.com/#@WalgreensHealthNonProd.onmicrosoft.com/resource/subscriptions/c945a18b-dab8-4ac5-a8bd-8112afef0738/overview)
  * Subscription ID: `c945a18b-dab8-4ac5-a8bd-8112afef0738`
* [wh-nprod-vdi-01](https://portal.azure.com/#@WalgreensHealthNonProd.onmicrosoft.com/resource/subscriptions/e18622f0-1586-4772-8593-2791dd7d1c5f/overview)
  * Subscription ID: `e18622f0-1586-4772-8593-2791dd7d1c5f`
* [wh-nprod-vdi-02](https://portal.azure.com/#@WalgreensHealthNonProd.onmicrosoft.com/resource/subscriptions/5d9206aa-c786-4f9a-b9ed-627ac9d6dc6f/overview)
  * Subscription ID: `5d9206aa-c786-4f9a-b9ed-627ac9d6dc6f`
* [wh-nprod-vdi-03](https://portal.azure.com/#@WalgreensHealthNonProd.onmicrosoft.com/resource/subscriptions/904fc405-ce86-412b-aa1c-1c689eb7f38e/overview)
  * Subscription ID: `904fc405-ce86-412b-aa1c-1c689eb7f38e`


## Hub Networking
* Non-Production vWAN _(not imported yet)_
    * vHub
      * Address Space: `10.0.0.0/24`
    * VpnGateway
      * Client Pool: `192.168.0.0/24`
    * Hub Firewall
      * Public IP: `20.122.66.26`
      * Private IP: `10.0.0.132`
    * Hub Firewall Policy
    * Hub Firewall Policy Rules _(not imported yet)_
    > The policy rules will probably be split up into more consumable chunks


## Central Logging
* [Management & Security Log Analytics](./wh-nprod-globplat-seclaws-eastus2-01.json)
  * > This is shared between security engineering and cloud services
* [Subscription Audit Registration](./wh-np-subscription-datasources.json) _(Note: not idempotent - fails on update, duplicate record error)_


## Infrastructure Networking
* [Infrastructure VNET](./wh-int-infra-eastus2-vnet-01.json): The "Infra Zone" of the WH NP network
  * Address Space: `10.0.1.0/24`, `10.0.2.0/24`
* [Infra 01 NSG](./virtual-network-security-groups/wh-int-infra-eastus2-vnet-01-sn01-nsg.json)
* [Infra 01 Subnet](./virtual-network/wh-int-infra-eastus2-vnet-01-sn01.json): Delegated for running ADO build agents
  * Address Space: `10.0.1.0/27`
* [Infra 02 NSG](./virtual-network-security-groups/wh-int-infra-eastus2-vnet-01-sn02-nsg.json)
* [Infra 02 Subnet](./virtual-network/wh-int-infra-eastus2-vnet-01-sn02.json): Delegated for hosting containerized CCP services
  * Address Space: `10.0.1.32/27`
* [Infra 03 NSG](./virtual-network-security-groups/wh-int-infra-eastus2-vnet-01-sn03-nsg.json)
* [Infra 03 Subnet](./virtual-network/wh-int-infra-eastus2-vnet-01-sn03.json): Used for hosting acr agent pool on the Provisioning Registry
  * Address Space: `10.0.1.64/27`
* [Infra 04 NSG](./virtual-network-security-groups/wh-int-infra-eastus2-vnet-01-sn04-nsg.json)
* [Infra 04 Subnet](./virtual-network/wh-int-infra-eastus2-vnet-01-sn04.json): Infrastructure components 
  * Address Space: `10.0.1.96/27`
* [Infra 05 NSG](./virtual-network-security-groups/wh-int-infra-eastus2-vnet-01-sn05-nsg.json)
* [Infra 05 Subnet](./virtual-network/wh-int-infra-eastus2-vnet-01-sn05.json): Chef infrastructure 
  * Address Space: `10.0.1.128/27`
* [Infra 06 NSG](./virtual-network-security-groups/wh-int-infra-eastus2-vnet-01-sn06-nsg.json)
* [Infra 06 Subnet](./virtual-network/wh-int-infra-eastus2-vnet-01-sn06.json): Infrastructure monitoring solution (private endpoint to the environment)
  * Address Space: `10.0.1.160/27`
* [Infra 07 NSG](./virtual-network-security-groups/wh-int-infra-eastus2-vnet-01-sn07-nsg.json)
* [Infra 07 Subnet](./virtual-network/wh-int-infra-eastus2-vnet-01-sn07.json): Backup infrastructure 
  * Address Space:  `10.0.1.192/27`
  
## Central DNS
* [whnprod.com](./dns_zones/whnprod.com.json)
* [appserviceenvironment.net](./dns_zones/appserviceenvironment.net.json)
* [DNS Agent Identity](./nprod-infra-dns-agents-id-01.json)
  * ResourceID: `/subscriptions/c945a18b-dab8-4ac5-a8bd-8112afef0738/resourcegroups/nprod-infra-dns-agents-eastus2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/nprod-infra-dns-agents-id-01`
  * ObjectID: `00c3461c-e082-4192-8bcd-9dceb861625b`
  * ClientID: `fa1b4810-1620-4026-8cc9-df0f0ade8f71`
* [DNS container 01](./nprod-infra-dns-agents-aci-01.json)
* [DNS container 02](./nprod-infra-dns-agents-aci-02.json)


## Provisioning Services
* [Provisioning Identity](./nprod-infra-provisioning-agents-id-01.json)
  * ResourceID: `/subscriptions/c945a18b-dab8-4ac5-a8bd-8112afef0738/resourceGroups/nprod-infra-provisioning-agents-eastus2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/nprod-infra-provisioning-agents-id-01`
  * Object ID: `8473f4a8-3aee-4561-9c6e-29b3b2b6b554`
  * Client ID: `7118fff0-352f-4ecf-8fa2-b32fa9b43f4e`
* [Provisioning agents keyvault](./np-inf-prv-agents-kv-01.json)
* [Provisioning Registry](./nprodinfraprovisioningagentsacr01.json)
* [Provisioning Registry AgentPool](./npinfacr01pl01.json)
* [Provisioning Container 01](./nprod-infra-provisioning-agents-aci-01.json)
* [Provisioning Container 02](./nprod-infra-provisioning-agents-aci-02.json)
* [Provisioning Container 03](./nprod-infra-provisioning-agents-aci-03.json)
* [Container Image Repository](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_git/wh-ccp-vsts-agent)
* [Azure Compute Gallery](./nprodinfrabaseimagegallery01.json)


## Infra Services
* [Infra Services ASE](./rpu-nprod-infra-services-eastus2-ase-01.json)
  * IP Address: `10.0.1.36`
* [Infra Services Server](./patching/nprod-infra-services-dbsvr-01.json)
* [Infra Services Keyvault](./patching/nprod-infra-kv01.json)
* [Infra Services Storage](./patching/nprod-infra-storage-01.json)
* Hub Peering API:
  * [Peering API ASP](./ccp-peering-api-np-l-asp-01.json)
  * [Peering API Site](./ccp-peering-api.json)
    * Object ID: `0337c9aa-2600-4f7e-a26e-3c5f96d57c76`
    * URL: `https://ccp-peering-api.rpu-nprod-infra-svcs-eastus2-ase-01.appserviceenvironment.net`
    * Repository: [wh-ccp-peering-api](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_git/wh-ccp-peering-api)
* Patching Service:
  * [Patching Services ASP](./patching/ccp-patching-np-l-asp-01.json)
  * [Patching Repositories Site](./patching/ccp-rmt-app-site.json)
    * URL: `https://ccp-rmt.rpu-nprod-infra-svcs-eastus2-ase-01.appserviceenvironment.net`
    * Repository: [wh-ccp-repository-management](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_git/wh-ccp-repository-management)
  * [Patching Repositories DB](./patching/rmt-sql-database-parameters.json)
  * [Patching Management Site](./patching/ccp-sms-app-site.json)
    * URL: `https://ccp-sms.rpu-nprod-infra-svcs-eastus2-ase-01.appserviceenvironment.net`
    * Repository: [wh-ccp-server-management](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_git/wh-ccp-server-management)
  * [Patching Management DB](./patching/sms-sql-database-parameters.json)
  * [Patching Repositories Share](./patching/nprod-infra-storage-01-share.json)



## Tags
Tags are applied to each subscription based on their classification _(parent management group)_

Builtin "Inherit a tag from the subscription" policies are assigned at the "walgreens-health-nprod" scope for each of the billing tags
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

### Non-Production
```ps
@{"CostCenter"="Healthcare Development 5004";"CostCode"="1000609920";"Department"="Innovation H3";"LegalSubEntity"="Walgreen Co";"SubDivision"="Innovation H3";"SubscriptionEnvironment"="Non-Production";"SubscriptionGroupArea"="WalgreensHealth"}
```
## Monitoring and Alerting

* Repository: [wh-ccp-azure-state](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_git/wh-ccp-azure-state?path=/nprod_management/monitoring)

### Alerts
* [SQL DB](/nprod_management/monitoring/alerts/sql-database)
  * [nprod-infra-services-dbsvr-01-master](/nprod_management/monitoring/alerts/sql-database/alert-metric-sql-db-nprod-infra-services-dbsvr-01-master-cpu-greater-70-percent.json)
  * [nprod-infra-services-dbsvr-01-rmt](/nprod_management/monitoring/alerts/sql-database/alert-metric-sql-db-nprod-infra-services-dbsvr-01-rmt-cpu-greater-70-percent.json)
  *[nprod-infra-services-dbsvr-01-sms](nprod_management/monitoring/alerts/sql-database/alert-metric-sql-db-nprod-infra-services-dbsvr-01-sms-cpu-greater-70-percent.json)
* [Virtual Machines](/nprod_management/monitoring/alerts/virtual-machines)
  * [anaibkdzp1la002](/nprod_management/monitoring/alerts/virtual-machines/anaibkdzp1la002)
  * [anaibknmp1la002](/nprod_management/monitoring/alerts/virtual-machines/anaibknmp1la002)
  ### Alerts
* [storage account](/nprod_management/monitoring/alerts/)
  * [nprodinfrastorage01](/nprod_management/monitoring/alerts/alert-activity-storageaccount-nprodinfrastorage01-createupdate.json)
  * [nprodinfrastorage01](/nprod_management/monitoring/alerts/alert-activity-storageaccount-nprodinfrastorage01-delete.json)
  * [nprodinfrastorage01](/nprod_management/monitoring/alerts/alert-activity-storageaccount-nprodinfrastorage01-failover.json)
  * [nprodinfrastorage01](/nprod_management/monitoring/alerts/alert-metric-storageaccount-nprodinfrastorage01-availability-lessthan50.json)
  * [whinteast2backend](/nprod_management/monitoring/alerts/alert-activity-storageaccount-whinteast2backend-createupdate.json)
  * [whinteast2backend](/nprod_management/monitoring/alerts/alert-activity-storageaccount-whinteast2backend-delete.json)
  * [whinteast2backend](/nprod_management/monitoring/alerts/alert-metric-storageaccount-whinteast2backend-availability-lessthan50.json)
  * [whinteast2backend](/nprod_management/monitoring/alert-activity-storageaccount-whinteast2backend-failover.json)
  *[nprod-infra-services-dbsvr-01-sms](nprod_management/monitoring/alerts/sql-database/alert-metric-sql-db-nprod-infra-services-dbsvr-01-sms-cpu-greater-70-percent.json)
*[storageaccount-enable-diagnostics](/nprod_management/monitoring/enable-logs-diagnostics)
 [nprodinfrastorage01](/nprod_management/monitoring/enable-logs-diagnostics/storage-acocunt/enable-diagnostics-storage-account-nprodinfrastorage01.json)
 *[whinteast2backend](/nprod_management/monitoring/enable-logs-diagnostics/storage-acocunt/enable-diagnostics-storage-account-whinteast2backend.json)
