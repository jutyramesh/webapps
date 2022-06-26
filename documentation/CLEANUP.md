# CCoE Sandbox Automatic Cleanup

* [Back to Table of Contents](README.md)

To help control costs, and reduce security exposure windows, the CCoE Sandbox usage guidelines recommends
regular cleanup of resources within a sandbox.

To facilitate this in an automatic manner we run a [scheduled pipeline](../pipeline/cleanup.yml) daily
and remove resources that have existed beyond a specific threshold unless otherwise marked for retention by
executing the [Clean-Subscription.ps1](../pipeline/Clean-Subscription.ps1) script.

It looks for two tags on resources to determine the appropriate actions to take and acts accordingly based on what
is found.

Resources picked up in the scan are marked for cleanup **14 days** after they are first detected



## Cleanup Sequence 

The cleanup sequence interacts with resources by detecting and setting specific tags on them

### Tags:
* `Persistent`: The value of this tag is not checked, though by convention we give it the string value `true`
* `ExpireOn`: This holds a date value in the format of `"yyyy-MM-dd"` for conversion and interpretation

Resources tagged `'Persistent' = 'true'` are logged in the output of the execution and noted that they will not be cleaned up
All persistent entries will be printed to the log under the header **"The following resources are marked for persistence and will not be deleted:"**

Resources that are not tagged 'Persistent' and do not have an 'ExpireOn' tag are picked up next.
These resources get marked with an `"ExpireOn": "yyyy-MM-dd"` tag where `"yyyy-MM-dd"` is the current run time.

Resources tagged in this phase are logged under the header **"New resources detected since last run:"**

Next the list of resources that have an `"ExpireOn"` tag with a date that is more than 14 days ago at run time are processed.
These resources are all deleted, and an entry is written to the log with details about the resource, resource group, and type.

Resources deleted are listed under the header **"Expired resources:"**

In the event that any resources cannot be cleaned, which happens from time to time due to the order in which they are processed
where one resource cannot be deleted before another, they will be captured and logged under the header **"The following resources could not be cleaned up:"**
These types of errors do occur, and will self resolve within a day or two since the cycle continues and moves on to the dependency and removes it
meaning the dependent resource can be cleaned up successfully the following day/run.

In the final phase of execution, any empty resource groups are detected and deleted



## Persistent & Long-Running Resources

Not all resources should be cleaned up when your entire ecosystem exists within the same sandbox subscription.
Things like a central hub network, and remote access capabilities that are maintained for long periods of time to facilitate usage
of the sandbox.

In other cases, you may be building a complex scenario to test that will take longer than 14 days, though there are other ways to handle this so that
resources are not ignored forever



### Persistent Resources

For those cases where you are establishing a persistent resource that makes up the scaffolding of the sandbox 
_(such as the agents that this cleanup operation runs on)_ you can tag a resource `"Persistent": "true"` to ensure it is not
cleaned up as part of this process.


### Long-Running Resources

For resources that need to exist for longer than the standard 14 day period but still should have a specified end time, you can either
explicitly set, or modify after the first pass, the value of the `"ExpireOn"` tag to a date in the future. Once set, the cleanup scan will
not modify this value again.

> There is a small potential that the `"ExpireOn"` tag could be removed through subsequent updates to the resource.
> In this case, the scan will pick it up as new, and re-scope it for cleanup, but the clock will have been effectively reset.

For resources that should be subject to cleanup, but not within the standard 14 day window should use this method instead of
marking it as Persistent on the expectation of cleaning it up later, which increases the risk of it being forgotten about.

Persistent resources are reported on each scan to allow for ongoing review.
