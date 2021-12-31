# Detective Controls
This page summarizes various questions to ask related to the Detective Controls pillar.

## Questions

* **Does my service natively integrate into cloud watch or does it need to be enabled/configured?**
    * e.g. step functions requires separate config

<br/>

* **Does my service natively integrate into Cloud Trail? If so what events are handled?**

<br/>

* **Is there any ‘extra’ layer of auditing/monitoring I should enable for the service? (e.g. API gateway access logging)**

<br/>

* **Can my logs provide enough information to info sec if a security incident ocurrs?**

<br/>

* **Are there alarms I should create to detect security issues?**
    * e.g. numberOfMessageSent to Queue > 100 per hour

<br/>

