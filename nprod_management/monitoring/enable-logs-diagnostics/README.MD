# Walgreens Health - Non-Production Management Resource Enable:

This document provides the requirements to capture and store logs and diagnostics in the management plane 

## Centralized Monitoring in the management subscription: 
- Resource group name: wh-nprod-globplat-security-rg-eastus2-01
- Storage accounts for logs: N/A
- Log Analytics Workspace: 
    "workspaceRegion": "eastus2",
    "workspaceResourceId": "/subscriptions/c945a18b-dab8-4ac5-a8bd-8112afef0738/resourcegroups/wh-nprod-globplat-security-rg-eastus2-01/providers/microsoft.operationalinsights/workspaces/wh-nprod-globplat-seclaws-eastus2-01"


### Naming Convention 

* Alert Naming Convention: 
    - enable-[log type]-[resource-type]-[resource-name]
    - Ex: enable-diagnostics-firewall

* Alert Param File Naming Convention: 
  - enable-[log type]-[resource-type]-[resource-name]
  - Ex: enable-diagnostics-firewall-AzureFirewall_wh-int-nvhub-eastus2-vhub-01

## Template reference to enable resource diagnostics 
- [app-service-environment](./hosting-environment/enable-diagnostics-hosting-environment-rpu-nprod-infra-svcs-eastus2-ase-01.json)
- [app-service-plan](./app-service-plan/enable-diagnostics-app-service-plan-ccp-patching-np-l-asp-01.json)
- [app-service](./app-service/enable-diagnostics-site-ccp-sms.json)
- [firewall](./firewall/enable-diagnostics-firewall-name.md)