## Example Parameter File: enable-firewall-dinostics
The Azure firewall AzureFirewall_wh-int-nvhub-eastus2-vhub-01 already have diagnostics enabled perform manually. This example is used for the future (prod environment) to enable diagnostics. 

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "resourceName": {
            "value": "AzureFirewall_wh-int-nvhub-eastus2-vhub-01"
        },
        "settingName": {
            "value": "enable-firewall-diagnostics"
        },
        "logAnalyticResourceID": {
            "value": "/subscriptions/c945a18b-dab8-4ac5-a8bd-8112afef0738/resourcegroups/wh-nprod-globplat-security-rg-eastus2-01/providers/microsoft.operationalinsights/workspaces/wh-nprod-globplat-seclaws-eastus2-01"
        },
        "logTypes": {
            "value": [
                {
                    "category": "AzureFirewallApplicationRule",
                    "enabled": true,
                    "retentionPolicy": {
                        "days": 30,
                        "enabled": true
                    }
                },
                {
                    "category": "AzureFirewallNetworkRule",
                    "enabled": true,
                    "retentionPolicy": {
                        "days": 30,
                        "enabled": true
                    }
                }
            ]
        },
        "metricTypes": {
            "value": [
                {
                    "category": "AllMetrics",
                    "enabled": true,
                    "retentionPolicy": {
                        "enabled": true,
                        "days": 30
                    }
                }
            ]
        }
    }
}