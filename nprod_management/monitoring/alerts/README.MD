# Walgreens Health - Non-Production Management Resource Alerts 
WH resources in the non-production management plane/subscription are configured with WBA alerts to be compliance with Walgreens. 

## Naming Conventions: 
* Alert Naming Convention: 
  - [alert type]-when-[resource-type]-[resource-name]-[condition]-[value] 
Ex: alert-metric-when-eventhub-eventsmessage-cpu-greater-than-average-80-percent

* Alert Param File Naming Convention: 
    - [alert type]-[resource-type]-[resource-name]-[condition]-[value]
Ex: alert-metric-eventhub-eventsmessage-cpu-greater-than-average-80-percent


## Centralized Resource Group for Management Subscription Alerts

- **Resource Groups Name: wh-int-infra-eastus2-alerts-rg**

## Centralized Action Group for Management Subscription

- **/subscriptions/c945a18b-dab8-4ac5-a8bd-8112afef0738/resourceGroups/wh-int-infra-eastus2-alerts-rg/providers/microsoft.insights/actiongroups/WH-CCP-NPROD**
- Reference [action-group-ccp.json](./action-groups/action-group-ccp.json)

### Alerts in the whnprod environment: 

| Resource Name       | Alert  Description   | Severity  |Links  |
| ------------- |:-------------:| -----:|:-------------:|
| AzureFirewall_wh-int-nvhub-eastus2-vhub-01    | when resource is down or unavailable | 0 - Critical | [alert-metric-when-azurefirewall_wh-int-nvhub-eastus2-vhub-01-average-health-status-less-than-100](./firewall/alert-metric-firewall-vwan-unhealthy.json) |
| AzureFirewall_wh-int-nvhub-eastus2-vhub-01      | when resource health is below 100 percentage      |  3 - informational |  [alert-metric-when-azurefirewall_wh-int-nvhub-eastus2-vhub-01-average-health-status-less-than-100](./firewall/alert-metric-firewall-vwan-health-below-100-percent.json)|
| rpu-nprod-infra-svcs-eastus2-ase-01  | when resource cpu is greater than 70    |  3 - informational |  [alert-metric-when-app-service-environment-rpu-nprod-infra-svcs-eastus2-ase-01-cpu-greater-than-70-percent](./app-service-environment/alert-metric-app-service-environment-rpu-nprod-infra-svcs-eastus2-ase-01-cpu-greater-than-70-percent.json)|
| ccp-peering-api-np-l-asp-01    | Delete App Service Plan detected  |  |[alert-activity-app-service-plan-ccp-peering-api-np-l-asp-01-delete.json](./app-service-plan/app-service-plan-ccp-peering-api-np-l-asp-01-delete) |
| ccp-peering-api-np-l-asp-01    | Join App Service Plan detected  |  |[alert-activity-app-service-plan-ccp-peering-api-np-l-asp-01-join.json](./app-service-plan/alert-activity-app-service-plan-ccp-peering-api-np-l-asp-01-join.json) |
| ccp-peering-api-np-l-asp-01    | Restart App Service Plan detected |  |[alert-activity-app-service-plan-ccp-peering-api-np-l-asp-01-restart.json](./app-service-plan/alert-activity-app-service-plan-ccp-peering-api-np-l-asp-01-restart.json) |
| ccp-peering-api-np-l-asp-01    | Create App Service Plan detected  | | [alert-activity-app-service-plan-ccp-peering-api-np-l-asp-01-write.json](./app-service-plan/alert-activity-app-service-plan-ccp-peering-api-np-l-asp-01-write.json) |
| ccp-peering-api-np-l-asp-01    | CPU utilization is more than 80 percentage | 2 - Warning | [alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-cpu-util-greater-than-80-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-cpu-util-greater-than-80-percent.json) |
| ccp-peering-api-np-l-asp-01    | CPU utilization is more than 90 percentage | 1 - Error | [alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-cpu-util-greater-than-90-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-cpu-util-greater-than-90-percent.json) |
| ccp-peering-api-np-l-asp-01    | Memory utilization is more than 80 percentage | 2 - Warning | [alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-memory-util-greater-than-80-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-memory-util-greater-than-80-percent.json) |
| ccp-peering-api-np-l-asp-01    | Memory utilization is more than 90 percentage | 1 - Warning | [alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-memory-util-greater-than-90-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-peering-api-np-l-asp-01-memory-util-greater-than-90-percent.json) |
| ccp-patching-api-np-l-asp-01    | Delete App Service Plan detected  | | [alert-activity-app-service-plan-ccp-patching-api-np-l-asp-01-delete.json](./app-service-plan/app-service-plan-ccp-patching-api-np-l-asp-01-delete) |
| ccp-patching-api-np-l-asp-01    | Join App Service Plan detected  | | [alert-activity-app-service-plan-ccp-patching-api-np-l-asp-01-join.json](./app-service-plan/alert-activity-app-service-plan-ccp-patching-api-np-l-asp-01-join.json) |
| ccp-patching-api-np-l-asp-01    | Restart App Service Plan detected  | | [alert-activity-app-service-plan-ccp-patching-api-np-l-asp-01-restart.json](./app-service-plan/alert-activity-app-service-plan-ccp-patching-api-np-l-asp-01-restart.json) |
| ccp-patching-api-np-l-asp-01    | Create App Service Plan detected  | | [alert-activity-app-service-plan-ccp-patching-api-np-l-asp-01-write.json](./app-service-plan/alert-activity-app-service-plan-ccp-patching-api-np-l-asp-01-write.json) |
| ccp-patching-api-np-l-asp-01    | CPU utilization is more than 80 percentage | 2 - Warning | [alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-cpu-util-greater-than-80-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-cpu-util-greater-than-80-percent.json) |
| ccp-patching-api-np-l-asp-01    | CPU utilization is more than 90 percentage | 1 - Error | [alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-cpu-util-greater-than-90-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-cpu-util-greater-than-90-percent.json) |
| ccp-patching-api-np-l-asp-01    | Memory utilization is more than 80 percentage | 2 - Warning | [alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-memory-util-greater-than-80-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-memory-util-greater-than-80-percent.json) |
| ccp-patching-api-np-l-asp-01    | Memory utilization is more than 90 percentage | 1 - Warning | [alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-memory-util-greater-than-90-percent.json](./app-service-plan/alert-metric-app-service-plan-ccp-patching-api-np-l-asp-01-memory-util-greater-than-90-percent.json) |
