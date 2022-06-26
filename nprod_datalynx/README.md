# Walgreens Health - Non-Production DataLynx Subscriptions

All resources that make up the non-production infrastructure for DataLynx, including the data engineering and
data lake subscriptions.

Incoming branches are validated for changes or additions to the `nprod_datalynx` folder that will be
deployed after merge to the main branch

These environments are used for preflight deployment and configuration validation before implementing updates
to the live environments housing production data.


## Target Subscriptions
* [wh-nprod-dataengineering-01](https://portal.azure.com/#@WalgreensHealthNonProd.onmicrosoft.com/resource/subscriptions/74711008-33b9-4784-b1ea-76aab1287167/overview)
  * Subscription ID: `74711008-33b9-4784-b1ea-76aab1287167`
* [wh-nprod-datalake-01](https://portal.azure.com/#@WalgreensHealthNonProd.onmicrosoft.com/resource/subscriptions/abfc0594-579a-4a36-a089-d5bbb90c3c54/overview)
  * Subscription ID: `abfc0594-579a-4a36-a089-d5bbb90c3c54`


## Overall Address Space
* `10.255.0.0/21`


## DataLynx Networking
* [RESOURCE_NAME](PARAMETER_FILE_LINK): DESCRIPTION
  * Address Space: `10.255.x.x/x`

> List all subnet resources and their NSGs, with details
>
> Example:
> * [Infra 01 NSG](./wh-int-infra-eastus2-vnet-01-sn01-nsg.json)
> * [Infra 01 Subnet](./wh-int-infra-eastus2-vnet-01-sn01-nsg.json): Delegated for running ADO build agents
> * Address Space: `10.0.1.0/27`


> All resources should be grouped and detailed here with links to the actual resources, descriptions, and key details about them


## Data Lake Networking
* [RESOURCE_NAME](PARAMETER_FILE_LINK): DESCRIPTION
  * Address Space: `10.255.x.x/x`

> List all subnet resources and their NSGs, with details
>
> Example:
> * [Infra 01 NSG](./wh-int-infra-eastus2-vnet-01-sn01-nsg.json)
> * [Infra 01 Subnet](./wh-int-infra-eastus2-vnet-01-sn01-nsg.json): Delegated for running ADO build agents
> * Address Space: `10.0.1.0/27`


> All resources should be grouped and detailed here with links to the actual resources, descriptions, and key details about them


## Tags
Tags are applied to each subscription based on their classification _(parent management group)_

Builtin "Inherit a tag from the subscription" policies are assigned at the "walgreens-health-nprod" scope for each of the billing tags
_(SubscriptionEnvironment & SubscriptionGroupArea are not cascaded)_

```js
/subscriptions/74711008-33b9-4784-b1ea-76aab1287167
{
    "LegalSubEntity": "Walgreens Health",
    "SubDivision": "Walgreens Health",
    "Department": "Walgreens Health Organic Business",
    "CostCenter": "WAG Health Admin SG&A",
    "CostCode": "1000641601",
    "SubscriptionEnvironment": "Non-Production",
    "SubscriptionGroupArea": "WalgreensHealth"
}
```

```js
/subscriptions/abfc0594-579a-4a36-a089-d5bbb90c3c54
{
    "LegalSubEntity": "Walgreens Health",
    "SubDivision": "Walgreens Health",
    "Department": "Walgreens Health Organic Business",
    "CostCenter": "WAG Health Admin SG&A",
    "CostCode": "1000641601",
    "SubscriptionEnvironment": "Non-Production",
    "SubscriptionGroupArea": "WalgreensHealth"
}
```

### Non-Production
```ps
@{
    "LegalSubEntity"="Walgreens Health";
    "SubDivision"="Walgreens Health";
    "Department"="Walgreens Health Organic Business";
    "CostCenter"="WAG Health Admin SG&A";
    "CostCode"="1000641601";
    "SubscriptionEnvironment"="Non-Production";
    "SubscriptionGroupArea"="WalgreensHealth";
}
```
