# Secrets
This page summarizes various questions to ask related to the Secrets pillar.

## Questions

* **What secrets do I need to invoke dependencies?**
    * User/passwords, tokens, API key, HTTP Basic, etc.

<br/>

* **Where am I storing dependent credentials?**
    * secrets manager? (NOT Properties files in GIT)

<br/>

* **How often should I be rotating ‘secrets’?**

<br/>

* **How am I injecting secrets into my service? IaaC contains Key or value?**
    * E.g. Lambda env vars do what?

<br/>

* **How am I enforcing my code should have NO ‘secrets’ (e.g. AWS tokens, user/password, etc.):**
    * Code scanner? Code review?

<br/>

