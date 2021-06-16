# Basic 3-Tier AWS Architecture

This provides a simple 3-tier architecture on Azure Services. 

Ww will create 1 bastion host for adminsitration and Serverles Frontend + VM instances for Backend with an ASG for escalation

![alt text](../Images/them_new_architecture.png)

## Proposed Architecture
# Replataform
```
Unlike the lift and shift approach, in Re plataform approach, a portion of the application or the entire application is optimized before moving to the cloud. 

Replatform approach allows developers to reuse the resources they are accustomed to working with such as legacy programming languages, development frameworks, and existing caches in the application.

This will azure that minor changes won’t affect the application functioning.Organizations willing to automate certain tasks, as mentioned before moving databases to the Amazon Relational Database Service.Organizations looking to leverage more cloud benefits other than just moving the application to the cloud.If for moving an application to cloud the source environment is not supporting the cloud, then a slight modification is required.If the on-premise infrastructure is complex and hinders scalability and performance, replatform is a goodOrganizations willing to automate tasks which are essentials to operations, but are not the business priorities.
```

This architecture builds and includes the following components:

1 **Web app**
 * A typical modern application might include both a website and one or more RESTful web APIs. A web API might be consumed by browser clients through AJAX, by native client applications, or by server-side applications. For considerations on designing web APIs, see API design guidance.

2 **Front Door**
 * Front Door is a layer 7 load balancer. In this architecture, it routes HTTP requests to the web front end. Front Door also provides a web application firewall (WAF) that protects the application from common exploits and vulnerabilities.

3 **VM instance with ASG**
 * Legacy process will be handled and deployed in a VM instance with an ASG attached to it, ASG scaling rule will be base on CPU consumption.

4 **Database**
 * a Azure SQL instance will be deployed, and a Data Migration plan to Mirror the current Schema to the new DB. Optimizing Cost

5 **Queue**
 * In the architecture shown here, the application queues background tasks by putting a message onto an Azure Queue storage queue. The message triggers a the process app. Alternatively, we can use Service Bus queues. 

6 **CDN**
 * Use Azure Content Delivery Network (CDN) to cache publicly available content for lower latency and faster delivery of content.

7 **Data storage**
 * Blobl Storage for CDN static files

8 **Azure DNS**
 * Azure DNS is a hosting service for DNS domains, providing name resolution using Microsoft Azure infrastructure. By hosting your domains in Azure, you can manage your DNS records using the same credentials, APIs, tools, and billing as your other Azure services.

9 **Express Route**
 * Will be user to handle conenction with On-premise core applications withouth going to the public layer, enforcing security.

10 **Cache**
*  Store semi-static data in Azure Cache for Redis from routine calls to Core process.

## Apply

After you run `terraform apply` on this configuration, it will
automatically output the DNS address of the ELB. After your instance
registers, this should respond with the default nginx web page.

To run, configure your Azure provider as described in 

https://www.terraform.io/docs/providers/azurem/index.html

Run with a command like this:

```
terraform apply -var 'ssh_public_key=location_of_public_key' -var public_key=ssha-rsa for bastion connection' 
```

For example:

```
terraform apply -var 'ssh_public_key=~/.ssh/id_rsa.pub' -var 'public_key=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCohXWgFUTuzH1Jmbo+TB+b85kR/7D/0L1'    
```
