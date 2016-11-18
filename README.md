# SONATA tests
This repository contains integration tests for SONATA's Service Platform. They have been divided in different subprojects depenending on the modules and the features to be tested. Designed to run in Jenkins, each project consists of:
<ul>
<li>A <b>deployment script</b> setting the initial environment of the test, performing tasks as starting required Dockers or filling databases with initial configutation.</li>
<li>One or several scripts implementing the <b>tests</b></li>
<li>A <b>resources</b> folder, containing additional resources needed when running the test, such has NSDs, VNFDs, sample requests, sample responses, etc. </li>
<li>A <b>Jenkinsfile</b> containing the Jenkins pipeline, which describes the required steps to perform the job.</li>
</ul>

All the integration tests of this repository are described with more details in the Continuous Integration/Continuous Delivery section of the [SONATA wiki](http://wiki.sonata-nfv.eu/index.php/CI/CD_Task_Force#Integration_Tests), defining, for each test, the list of involved componentes, the list of involved US and a diagram describing the workflow of the test.

## Contained projects

#####int-bss-gkeeper
Integration tests between the Business Support System and the Gatekeeper. The tested features are:
<ul>
<li>Retrievement of the list of active services</li>
<li>Single service instantiation</li>
<li>Polling of the service instantiacion status</li>
</ul>

#####int-gtkpkg-sp-catalogue
Integration test betwen the Gatekeeper and the Catalogue for packages. The scripts included in this project test that:
<ul>
<li>After sending a Package to the Gatekeeper, the Catalogue is storing it.</li>
<li>When requesting a Package to the Gatekeeper (by id or by "vendor,name,version" trio, Gatekeeper retrieve it from Catalogue and sends it to the user.</li>
<li>User is able to get the list of Packages stored in Catalogue through the Gatekeeper</li>
</ul>

#####int-gui
Tests for the Graphical User Interface. This set of integration test procedures consist of several Grunt tasks (http://gruntjs.com) which perform connectivity checks between GK-GUI implementation with Gatekeeper and Monitoring server. The features tested are:
<ul>
<li>Requesting a package from GK</li>
<li>Requesting functions from GK</li>
<li>Requesting services from GK</li>
<li>Displayiing SP monitoring data on the GUI</li>
<li>Deploying a new Network Service through GK</li>
</ul>

#####int-mano-plugin-management
Tests for the plugin management functionalities of MANO framework. It checks the correct registration and unregistration of plugins from the SON MANO framwork by implementing a testing plugin.

#####int-mon
Integration tests for the Monitoring of the Service Platform. This test procedure checks the connectivity between Monitoring server and Infrastructure components (SLM, Monitoring probes and Message Broker). The tests are based on a VNF with a monitoring rule, which is triggered in order to produce an alarm. The list of tested features is:
<ul>
<li>The correct connectivity between the Service Platform monitoring probe and the Monitoring Server.</li>
<li>The correct connectivity between a Virtual Machine monitoring probe and the Monitoring Server.</li>
<li>The correct reconfiguration process triggered by the deployment of a new NS/VNF.</li>
<li>The correct execution of the alerting mechanism triggered by a predefined rule and sent via Message Broker. </li>
</ul>

#####int-sdk
Inntegration tests for the SDK. The SDK is composed by a lot of tools, and supports a wide set of workflows. In this project the CLI is tested. It consists of different independent tools, which are the <b>son-workspace</b>, the <b>son-package</b> and the <b>son-publish</b>

The test starts with an empty filesystem, creates a workspace, a project, and packages it, following a set of orderes steps:
1. Creation of a new workspace
2. Workspace configuration
3. Creation of a new project
4. Publishment of the project
5. Package the project
6. Remove project components
7. Repackage the project
8. Instantiate the package.




#####int-service-instantiation
Integration tests covering the communication between the Gatekeeper and the MANO framework when deploying a new service.
When user requests to Business Support System (BSS) to instantiate a new service, Gatekeeper passes the Network Service Descriptor(NSD) and the Virtual Network Functions Descriptors (VNFDs) to the MANO framework in order to request a service instantiation. The tests included in this project check following assumptions after requesting a service instantiation to the Gatekeeper:
<ul>
<li>Gatekeeper builds the request targeted to Mano framework</li>
<li>Gatekeeper sends through RabbitMQ the request and SLM receives it</li>
<li>SLM informes about the service deployment status to the GK</li>
<li>Instances can be retrieved from catalogies</li>
</ul>


#####int-slm-infrabstract
Integation tests between the Service Lifecycle Manager (SLM) and the Infrastructure Adapter. Upon receiving a service deployment request, the SLM would contact the Infrastrucure Adapter to get the list of VIMs and their resources. After that, a basic placement would be executed. The tests included in this project perform following checks:
<ul>
<li>Checking the response of the Infrastructure Adapter on the infrastructure.management.compute.list and infrastructure.service.deploy topics when a service request is being handled</li>
<li>Verification of the deployment itself on Openstack</li>
</ul>

#####int-slm-repositories
Integration tests between the Service Lifecycle Manager and the NSR/VNFR Repositories. After deploying a service upon a service deployment request, SLM should store the Network Service Record and the Virtual Network Function Records in the repository, building them from the Infrastructure Adapter response and the according NSD and VNDs. It also triggers the monitoring process by sending a custom message to the Monitoring Manager. The test included in this task triggers this process simulating an Infrastructure Adaptor response to the service deployment request and it's checked that:
<ul>
<li>SLM has built expected NFR/VNFRs and they are stored in the repositories.</li>
<li>Monitoring Manager has been triggered and its database contain the information of the deployed service.</li>
</ul>

#####int-sp-instantiation
Service Platform instantiation. This test tries to deploy all major components of the service platform. The goal is to verify that all components are in a deployable state and can directly interact with each other after they have been deployed on a single system.


#####son-logging-amqp
Tests for the RabbitMQ communication between components of the SONATA Service Platform. Some of the modules composing the SONATA SP communicate through RabbitMQ. The script included in this project connects to the RabbitMQ server and prints all messages that the different modules exchange.

#####son-sdk-nginx-dynamic
NGINX is a free, open-source, high-performance HTTP server and reverse proxy, as well as an IMAP/POP3 proxy server. NGINX is known for its high performance, stability, rich feature set, simple configuration, and low resource consumption. This project contains an eample on how to deploy it in a docker by listening requests on port 80.

## Contributing to this repository

In order to contribute to repository, you'll need to:
1. Clone this repository
2. Code your test including a deployment script, your tests and a Jenkinsfile.
3. Submit a Pull Request
4. Document the integration test in SONATA wiki using the Integration Test [template](http://wiki.sonata-nfv.eu/index.php/Integration_Test_Template) You can find a use the [integration test example](http://wiki.sonata-nfv.eu/index.php/Integration_Test_Example) as a guide for documenting your tests.

## License
The license of the SONATA Integration Tests is Apache 2.0