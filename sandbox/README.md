# Walgreens Health - Sandbox Resources

Cloud / Infrastructure resources (short term) that are being deployed and tested into the sandbox

> Make sure you've read the **[CCoE Sandbox Guidance](../documentation/SECURITY.md)** and follow it when
> working in the sandbox

> This will not be an inclusive list of resources deployed in the sandbox since it is shared
> and often-times, experimentation starts with manual deployment and configuration.

For any resources deployed through the deployment system that will exist for anything longer than a trivial
amount of time, make sure to put a note in here about what it is and what you are doing.

Sandbox resources are subject to regular cleanup activities and may need to be redeployed if they
are left unattended for too long.

> An automatic cleanup sequence is planned for the sandbox subscription, more details will be provided when it is put in place


## Target Subscriptions
* [wh-nprod-sbox-01](https://portal.azure.com/#@WalgreensHealthNonProd.onmicrosoft.com/resource/subscriptions/22be09a9-d858-4ffa-a5a8-3172283218d4/overview)
  * Subscription ID: `22be09a9-d858-4ffa-a5a8-3172283218d4`

  
## Networks

> Infrastructure testing networks should come out of the predesignated infra pool of `10.0.0.0/16` to not clash or overlap with application
> team testing operations and reduce coordination efforts.
>
> Refer to infrastructure network allocations for free space

# Chef Testing
* VNET: [wh-sbx-nprod-infra-eastus2-vnet-01](./wh-sbx-nprod-infra-eastus2-vnet-01.json)
* Address Space: `10.0.18.0/24`

# AD Join Testing
* VNET: [wh-sbx-nprod-infra-eastus2-vnet-02](./wh-sbx-nprod-infra-eastus2-vnet-02.json)
* Address Space: `10.0.19.0/24`

