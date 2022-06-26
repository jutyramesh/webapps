# Walgreens Health - Central State Tracking 

This is the repository of resource definitions that make up the core infrastructure components and services
deployed in the Walgreens Health non-production and production tenants through a light-weight _(localized deployment)_ version of the
Common Cloud Platform provisioning services Central State Tracking repository

Parameters are grouped into top level folders that represent environment levels that are controlled by separate workflows

This provides the ability to have separate conditions on the execution without treating them as a progression sequence

The top level directory layout is as follows:
* [pipeline](./pipeline/): This holds all of the pipeline definitions and helpers
* [documentation](./documentation/README.md): Break out documentation related to the Walgreens Health environments
* [templates](./templates/): Holds the local templates leveraged by the resource parameters
* [sandbox](./sandbox/README.md): top level folder for resources deployed into a sandbox environment tier
* [nprod-management](./nprod-management/README.md): top level folder for resources deployed into the non-production management plane to support the walgreens health non-production environments
* [prod-management](./prod-management/README.md): top level folder for resources deployed into the production management plane to support the walgreens health production environment

<br><br>

## Documentation

Documentation is separated into individual documents within the repository covering specific topics

General documentation can be found in the [documentation](./documentation/README.md) folder which includes a table of contents

<br><br>

## Environment Layout

There are three major environments governed by this deployment service.

The full [CCP Deployment System](https://dev.azure.com/WBA/IT%20Services/_wiki/wikis/Common%20Cloud%20Platform/158/Common-Cloud-Platform) is not available in this area yet, but provisioning activities are still
subject to the same guidance and rules around individual resource capabilities it normally enforces.

Templates for resources should be taken from, and kept in sync with the [CCP Deployment System](https://dev.azure.com/WBA/IT%20Services/_wiki/wikis/Common%20Cloud%20Platform/158/Common-Cloud-Platform) to ensure enterprise consistency is followed as closely as possible here.

> Some aspects do not apply or have different values due to the detached nature of the Walgreens Health ecosystem.

For more details on the local deployment system and its pipeline setup, checkout the [PIPELINE.md](./documentation/PIPELINE.md) in the documentation section



### [Sandbox](./sandbox/README.md)

> Additional details can be found in the [Sandbox README.md](./sandbox/README.md)

The sandbox is a testing ground for experimenting with builds and testing how things will work before you apply changes to higher environments
that could introduce impact to people operating in those environment.

As the Infrastructure team we have the onus of maintaining a stable consumable set of services that underpin the entirety of multiple application environments
and support staff access and desktop capabilities.

This means we really have two production environments to take care of, since the management services for non-production _(while not able to impact customer experience directly)_ are still of critical importance to the productivity of development teams working on the source code and testing in preparation for
a production release.

#### As the joke goes:
> _Everyone has a test environment_
> 
> _Some people are lucky enough that they have a separate environment for running production._


For major renovations, adequate testing should be performed before making changes to either the non-production or production management services
that could impact their respective downstream consumers.

Using a sandbox comes with its own considerations. **Please read the [CCoE Sandbox Guidance](./documentation/SECURITY.md)** provided in the documentation
section and follow it when working in the sandbox.

> Keep in mind that this is not a dedicated sandbox for us, it is shared with the application and application delivery teams



### [Non-Production Management Plane](./nprod_management/README.md)

> Additional details about resources can be found in the [Non-Production Management Plane README.md](./nprod_management/README.md)
> including key information about foundational aspects of the management plane used in other configurations.

Servicing the Walgreens Health non-production environments, the [non-production management plane](./nprod_management/README.md)
includes central services that provide connectivity and governance, into and between environments, desktop pools, central infrastructure build capabilities,
central security tooling, and identity services.

> Don't let the name fool you, this is not a non-production environment to us.

We are following a fully declarative model for this environment, meaning resource definitions must be captured and controlled through
state files contained within this section of the repository. All resource creation and change activities that do are not modified
as part of the running state of a service should be introduced through these definitions and then driven through the deployment system sequence.

This area is not subject to just in time access restrictions, and role assignments for both team and machine access should be captured
in the declarative state of the resources. As per our standard governance you should avoid assignment of roles to individual human accounts.



### [Production Management Plane](./prod_management/README.md)

> Additional details about resources can be found in the [Production Management Plane README.md](./prod_management/README.md)
> including key information about foundational aspects of the management plane used in other configurations.

Servicing the Walgreens Health production environments, the [production management plane](./prod_management/README.md)
includes central services that provide connectivity and governance, into and between environments, desktop pools, central infrastructure build capabilities,
central security tooling, and identity services.

The production environment and its supporting infrastructure capabilities and services are subject to [HITRUST](https://hitrustalliance.net/) controls due to
the applicability of the application that it hosts and supports. _This means there are significant expectations of controls being in place to restrict, control_
_and audit access to systems containing sensitive customer data._

**ALL** changes to infrastructure **MUST** be captured for audit purposes, and released through controlled gates that introduce validation, and execute
only after those validations have taken place.

> This repository and its deployment system pipelines act as that validation and release mechanism

Unlike the non-production environment, **ALL** human access to this environment at an Azure resource level is governed with just in time privilege elevations.
This means that no human group assignments should exist on any resource or a parent directly, and that concept is used to audit the production environment.

All machine access should be included in the declarative state for the resources to enable authorized communication between two services.


<br><br>


## Getting Help

For assistance with infrastructure deployment capabilities contact [CommonCloudPlatform@Walgreens.com](mailto:CommonCloudPlatform@Walgreens.com)
