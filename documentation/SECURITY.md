# CCoE Sandbox Security Guidance

* [Back to Table of Contents](README.md)

A "Sandbox" is an interesting place where multiple concepts and paradigms coalesce into a pungent gumbo of experimentation, standards, 
best practices, security principles, and risk.

Its absolutely needed, especially for enterprise infrastructure teams trying to find their way through the ever changing landscape _(cloudscape?)_
of the public cloud.

> Its really hard to follow a standard you haven't created yet

We need to do all kinds of interesting and _potentially_ dangerous things while we figure out what does and doesn't work, and answering the important questions
of how and why.

You break everything, fix it again, break it again, crash the whole network, and then at some point around 4AM right when you were beginning to question your
career _and life_ choices, **IT WORKS!**

> I'm writing this at 7AM waiting for some configuration changes to apply, so this isn't entirely hypothetical here

This is why the Sandbox is so important, and it is so very important that it is **NO WHERE NEAR** anything **THAT EVEN LOOKS LIKE** your production network.

This presents some challenges when we get to those standards and security principles because most of what we do is based a variation of a 
["castle and moat"](https://www.cloudflare.com/learning/access-management/castle-and-moat-network-security/) style security _(not exactly as described in the link)_
where you have to come in through specific edges, and then everything inside is interconnected.

By definition, this means you are pretty close to production at all times, and network changes might be able to cause significant impacts to it.

To keep the sandbox away from that we cannot _really_ stay within the castle.

Its also important to understand that this is not your father's lab environment, this is the **public** cloud _(emphasis on the word public)_.
You should assume at all times, that the thing you are building is accessible on the internet, at least from a network perspective.

While this environment is not connected to anything real, and there is no way we could compromise real data, we still need to do our best
to ensure it is not wide open and compromised.

> Luckily, with only a few exceptions, almost every resource you could deploy in Azure has a **secure** _enough_ **by default** configuration

When experimenting in the Sandbox you still must follow some common sense configuration guidance to ensure things stay safe



## Guidance

Follow this guidance to minimize the risk of a bad actor getting in.


### CLEAN UP AFTER YOURSELF

> Time is money and stuff gets billed by the hour or minute in the cloud, security not withstanding, delete stuff when you are done

Removing resources when you are done with them is possibly the single most security-minded thing you can do when working in the Sandbox.

Even the l33tist haxor isn't going to find your resources POC right away. By deleting things when you are done you remove all possibility 
of it being compromised.



### Limit insecure configuration live time

It is often necessary to either build something following a guide you found on the [Microsoft website](https://azure.microsoft.com/en-us/get-started/) or to
check what happens when you change various configurations, testing how the service acts with a firewall on and off so you can properly account for the differences
in how it will interact in our target environment.

This testing is entirely appropriate, and the Sandbox is perfectly suited for it.

When you need to set up something that isn't adhering to our security standards, limit the amount of time you have it in that configuration.

For instance, turn the firewall off, do your test, and then turn it back on before you call it a day.



### Use AAD authentication where ever possible

Since it is probably going to be how it will end up being used anyway, you might as well figure out how to leverage AAD integrated authentication
if you can unless you are specifically testing what happens without it.

This allows you to use your individual user account to authenticate to the resource, or some other resource identity when you are working on connecting
two things together.

Make extra-double-really sure not to save your password anywhere that someone else might be able to see.


### Protect local credentials

There are certain technologies that only work with key-based authentication, or you may need to validate how they work with or without them.

When using key-based _(Account, SAS, API, or other)_ or local password authentication make sure that you:
* Don't share them anywhere online
* Don't commit them into a repository
* Disable or change them when you are done



### Use complex password

When you have to set a local password on a service _(there aren't too many of these anymore, most notable of the hold-outs though are Virtual Machines because they also support interactive login which is pretty rare as well)_ make sure you are setting a sufficiently complex one. 

Use a password generator and make it long and complex, don't reuse them, and definitely don't use one you use for something else outside of the Sandbox

When using password authentication:
* Don't share them anywhere online
* Don't commit them into a repository
* Disable or change them when you are done


### Keep it off the internet

Last but not least, when there is an option to reduce the exposure of the resource to the internet, do it.

Azure network security typically falls into one of the following patterns:
* In VNET Resources _(These may or may not also include a public IP interface which should be avoided)_
* Private Endpoints _(Public addressed resources fronted with a private address within a VNET)_
* Service Endpoints _(Public addressed resources that can be restricted to only accept traffic from named Subnets)_
* Public IP Firewalls _(Resource specific configurations that take public addresses that should be allowed)_
* None _(These are either, supposed to be completely accessible, or require strong identity authentication)_

Without getting into the details of how each of these types of network restrictions work, and how they can overlap with each-other,
This list is provided in order of preference when looking for how to configure a resource from a security perspective.

Strive to leverage network security when building resources and **ESPECIALLY** ensure Virtual Machines are protected from public access.
