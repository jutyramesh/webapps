# NSG Standards

Network Security Groups _(NSGs)_ are Azure's lightweight stateful firewall system WBA uses to govern traffic into and out of Subnets within azure.
 
Rules within an NSG are assigned a priority and are applied in reverse order _(lower numbers take priority over higher numbers)_



## Declarative Model

Each subnet has a unique NSG object capable of holding rules specific to the necessary inbound and outbound allowances tracked independently through a declarative state model, where the definition is held independent of the active state for the object in the running environment, and changes are introduced by altering the definition and replacing the active state.
 
NSGs are broken up into key sections to support a combination of common, and specific rules and the ability to change them independently with minimal coordination to handle common adjustments at enterprise scale.
 
These sections are represented as named entities and follow a priority numbering scheme to ensure rules cascade appropriately and can be introduced in a consistent way.
 
Rules are structured in a way to start from a secure closed base and add necessary allowances to allow valid traffic.
This also structures the NSG in a way that means all rules past the default deny rules, are allow rules. This reduces the likelihood of impacts to a running service in a few different ways.
1. Adding allows in any section will not be impactful.
2. Sections are separated based on purpose, and purpose owners can reason directly about the rules within that section when removing allowances that are no longer necessary
3. The least well-defined rules are of the highest priority, protecting them from being overridden and causing impact
 
No individual rule not adopted as part of the standard set should EVER be added to any of the generic priority ranges.
All subnet-specific, non-common rules should be added in the custom priority range, as all others are subject to centrally managed update activates. 


<br>

## Sections

### Base Rules
* Priority Range: `4096 - 4000`

Base rules start with default deny all rules that block traffic, and then provide allowances for support ranges (support staff user traffic)
 
As support ranges change, this value needs to be updated across all subnets, and adopted on all new instances automatically, meaning changes to this section should trigger a rollout of the updated state to all existing NSGs under control.

### Microsoft Rules
* Priority Range: `3999 - 3000`

Azure cloud services require outbound allowances for resources that are hosted within the context of a virtual network to allow them to function and remain healthy.

This used to include calculated address space ranges published by Microsoft, but has since been replaced due to the introduction of service tags, the section is maintained in the event of future needs, and a rule is still necessary to facilitate the connectivity.

While this section no longer sees regular updates, if it did, this value needs to be updated across all subnets, and adopted on all new instances automatically, meaning changes to this section should trigger a rollout of the updated state to all existing NSGs under control.

### Infrastructure Rules
* Priority Range: `2999 - 2000`

With automated deployment capabilities top of mind, WBA maintains specific network zones classified for hosting internal core capabilities (DNS, LDAP, AD, NTP, Configuration Management, Provisioning tools, Etc) that require inbound or outbound access across all networks to ensure systems can remain healthy and be maintained and facilitate build activities.
 
To support scaling, high availability, and regional facilitation of core services this zone is treated as a logically collapsed space, and necessary port allowances are specified to/from the zone.

As central infrastructure capabilities change, this value needs to be updated across all subnets, and adopted on all new instances automatically, meaning changes to this section should trigger a rollout of the updated state to all existing NSGs under control.


### Platform Rules
* Priority Range: `1999 - 1000`

Several platform services require specific allowances to facilitate the service health and functionality. These are captured as service specific allowances assuming no other allowances are in place, and assigned non-overlapping priorities
 
There are no current scenarios where common rules would be applied cumulatively to a single NSG, but non-overlapping priority assignments are used to protect against any future potential
 
Subnets that are designated to host a service are then able to be assigned an "intent" that drives the configuration across multiple configuration domains including NSGs, UDRs, and Egress firewall allowances
 
The full and actual list is maintained in the declarative state home, but some examples of common rule sets include:
* Azure Kubernetes Service (aks)
* Azure API Management (apim)
* Azure Application Gateway (appgw)
* Azure App Service Environment (ase)
* Azure Sequel Managed Instance (sqlmi)
* Azure Cache for Redis (Premium) (redis)
* Azure Batch Pool (batch)
* Azure HDInsights (hdi)
* Azure Databricks (dbx)
* Azure Data Explorer (adx)
 
These rules DO NOT cover access to or from the application / content hosted on the service, only for the service itself to function.
Application specific allowances belong in the local rules section
 
For example, the Kubernetes (AKS) common rules include an allowance for node-to-node communication to facilitate POD traffic as the service schedules, shifts, or scales workloads across them dynamically. It should not include an outbound allowance to the database hosted in another subnet as that is specific to the application hosted on it, nor should it allow inbound traffic to the frontend(s) of the application(s) hosted within the cluster, as that is also an application specific rule. Both of those belong in the local rules section.


### Local Rules
* Priority Range: `999 - 100`

Rules necessary to facilitate the application components hosted within a subnet are specified in the custom rules section. This moves all the most granular and highest priority rules to the top, and segments them from the centrally managed sections into their own named section that can be represented as part of the declarative state for an application environment definition to be injected either directly, or though submission.
 
This lends itself well to one of the principles of the democratized declarative state tracking pattern implemented by the Common Cloud Platform Deployment service, that the definition of an environment and all of its components should be stored and versioned together with or near the application source, while still separating and centrally maintaining the network security oversight and maintenance activities.
 
Application fragments hold details specific to the application, without holding centrally maintained values that need to be serviced outside of their purview.


<br>

## Automated Creation with Intent

Since NSGs are required on all subnets (and enforced by policy with no opportunity for deviation), a new unique definition must be created with each subnet being provisioned.
 
This can be done with a high degree of automation with support for three distinct scenarios since most or all the rules that would be necessary for a new subnet are stored as cleanly combinable fragments, assembly of a new NSG for use on a subnet is a matter of merging some or all of the sections and storing it into the state tracking system.


### No or General Intent

Creating a generic NSG or one with "general" intent is accomplished by combining the baseRules, microsoftRules, & infraRules sections together and saving it in the state tracking system as a new artifact for initial release and ongoing management.


### Service Intent

Creating an NSG with one of the service specific intents such as "aks" intent is accomplished by combining the baseRules, microsoftRules, & infraRules along with the aks specific platformRules sections together and saving it in the state tracking system as a new artifact for initial release and ongoing management.


### Application Intent

In cases where all or part of the localRules section are available at creation time, those can be included as an addition to a general or service specific intent to provide a single shot deployment.
 
In current case this is unlikely, though it provides a model for future wholistic provisioning capabilities triggered by self-service deployment activities with centrally controlled execution.
 
As things exist now, application intent is likely to be provided as a secondary event to the initial creation.
 
Additional checks must be performed when accepting application rule fragments to a shared subnet NSG, to ensure the rules are all allowances, and do contain conflicting priorities, since a single application rule set only contains a portion of the section being managed.



### Centrally Managed Updates

As support ranges are added or removed, and infrastructure services expand, changes need to be applied to all NSGs under management to ensure consistent availability of enterprise capabilities.
 
When changes to the baseRules, microsoftRules, or infraRules sources are introduced, and automatic push will be triggered, updating the relevant section of each NSG under management in groups progressing through environment types from lowest to highest with forced gates between major types.

Out of band changes should never be made to these sections, they are reserved for their stated purposes and changes that need to be made to them should be synchronized across all existing instances.


<br>


## Rule Definitions

Rules should be constructed in a consistent manner for easier readability

Note the order of the snippet below:
* Description
* Priority
* Direction
* Access Type
* Protocol
* Source Address(es)
* Source Port(s)
* Destination Address(es)
* Destination Port(s)


### Starter Snippet
```js
{
    "name": "Direction_Major_Minor_Access_Protocol",
    "properties": {
        "description": "Human readable description of the purpose",
        "priority": 500,
        "direction": "Inbound|Outbound",
        "access": "Allow|Deny",
        "protocol": "Tcp|Udp",
        "sourceAddressPrefix": "ServiceTag|*",
        "sourceAddressPrefixes": [],
        "sourcePortRange": "*",
        "sourcePortRanges": [],
        "destinationAddressPrefix": "ServiceTag|*",
        "destinationAddressPrefixes": []
        "destinationPortRange": "*",
        "destinationPortRanges": [],
    }
}
```
> This shows every option for properties. You do not need to include both source and destination variants
> when using one or the other. For example if you are using a service tag as the source you can use `"sourceAddressPrefix": "ServiceTag"`
> and remove `"sourceAddressPrefixes": []` since it is unused and does not require a list.
>
> That said; it would be better to consistently implement the list version even with a singular item, its just not required at this time



## Default NSG Building

For any given NSG, the parameter file would be a combination of `baseRules`, `microsoftRules`, `infraRules`, and where applicable the platform specific `platformRules` for the service that will consume the subnet.

These are always consistent, and should always be implemented in a way that allows them to be synchronized across ALL subnets.



## Implicit Targeting

the use of `*` rules in firewalls is generally considered a bad thing outside of fully open public front ends, which is true, and should be used as base guidance
when creating rules, and modified by the following conditions


### Outbound allowances from the subnet

In this case, an outbound rule from a dedicated subnet should use `*` in the `sourceAddressPrefix`. Since all outbound traffic being assessed by the NSG
is implicitly from within the subnet, and generic segments can be reused more easily then also support subnet logical collapsing without modification

> This is only applicable on dedicated service subnets _(AKS, APIM, ASE, etc)_ where you cannot account for the address allocation


### Inbound allowances to the subnet

[make words here]
