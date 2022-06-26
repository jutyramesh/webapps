# CCoE Local Pipline Configuration Guide

* [Back to Table of Contents](README.md)

This will include details about the setup and configuration of the repository, pipeline, and additional components not directly visible
to capture the steps taken to set it up so they can be replicated as necessary

The pipeline is setup to run in two flows
* Pre-Merge Validation ([validate.yml](../pipeline/validate.yml))
* Deployment ([deploy.yml](../pipeline/deploy.yml))

the validation stage will provide details about all pending changes for review before merge when the deploy pipeline will carry them out

<br><br>



## Agent Pools:
* [wh-np-ccp-agents](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_settings/agentqueues?queueId=21&view=jobs)
* [wh-p-ccp-agents](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_settings/agentqueues?queueId=22&view=jobs)


### Pool Token Settings:
* Service Account: svc-ccp-agent-pool-nprod@whnprod.com _(contact Josh Hetland)_
* Permissions: 
  * Build: Read & Execute
  * Agent Pools: Read & Manage

<br><br>



## Service Connections:
* [wh-np-ccp-connection](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_settings/adminservices?resourceId=a3367675-96ac-45f5-a1d7-62dd559d7715)
  * Scope: [NPROD Tenant Root](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/ManagmentGroupDrilldownMenuBlade/overview/tenantId/dec32715-7ca7-40c9-b658-a9acce8a39cc/mgId/dec32715-7ca7-40c9-b658-a9acce8a39cc/mgDisplayName/Tenant%20Root%20Group/mgCanAddOrMoveSubscription/true/mgParentAccessLevel//defaultMenuItemId/overview/drillDownMode/true)
  * Source: Managed Identity for ADO build agent
* [wh-p-ccp-connection](https://dev.azure.com/walgreens-health-services/Walgreens%20Health%20Services/_settings/adminservices?resourceId=18007d97-43c5-4511-96a4-676a33d5f0ed)
  * Scope: [PROD Tenant Root](https://portal.azure.com/#blade/Microsoft_Azure_ManagementGroups/ManagmentGroupDrilldownMenuBlade/overview/tenantId/43d2f056-2a0f-4a87-a552-1bbcec447cd1/mgId/43d2f056-2a0f-4a87-a552-1bbcec447cd1/mgDisplayName/Tenant%20Root%20Group/mgCanAddOrMoveSubscription/true/mgParentAccessLevel//defaultMenuItemId/overview/drillDownMode/true)
  * Source: Managed Identity for ADO build agent

<br><br>



## Repository Configurations:
* [main] Require min approvers 1
* [main] allow requestors to approve their own changes
* [main] limit merge types: squash merge
* Setup build pipeline/deploy.yml - Named wh-ccp-azure-state-deploy
* Created pipeline pipeline/validate.yml - Named wh-ccp-azure-state-validate
* [main] Created Build Validation "Pre-Merge Validation" from wh-ccp-azure-state-validate
* [main] Automatically included required approvers "Production Deployment" Path: /prod_management/* wh-np-ccoe-owners
* [main] Automatically included optional approvers "Non Production Deployment" Path: !/prod_management/* wh-np-ccoe-owners

<br><br>



## References
* [How to restrict a service connection to a specific branch](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass#required-template)
* [Configuring environment stage approvals](https://docs.microsoft.com/en-us/azure/devops/pipelines/process/approvals?view=azure-devops&tabs=check-pass#approvals)
* [Self-Hosted Agent Firewall Rules](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops#im-running-a-firewall-and-my-code-is-in-azure-repos-what-urls-does-the-agent-need-to-communicate-with)
