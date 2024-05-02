# ThousandEyes Project

[teapp](/teapp.py) is a containerized application that I created, which makes API calls to the Thousand Eyes API and retrieves test data. 
[teapp](/teapp.py) is containerized using Docker, allowing it to be redeployed easily.


[teapp](/teapp.py) was created given the following scenerio:

Using any available online resources to build a containerized application . The application
should make API calls to the [ThousandEyes application](https://developer.thousandeyes.com/v5/) and 
retrieve a list of all tests configured in your own [ThousandEyes application account]( https://www.thousandeyes.com/signup/ ). The output can be displayed in any format of your choice, such as through the console, logs, or a web interface.
The objective is to provide evidence of successful API calls and to report any vulnerabilities
found in the container/application/(information in transit).

Security hygiene throughout the architecting process was considered, including the following:
- How can you reduce the attack surface?
- Can you ensure the lightest-possible container footprint?
- Can you produce a container that can be seamlessly upgraded, re-deployed?
- Does any api or web interface properly escape any untrusted input?
- Can you build modern security header controls into your application?
- Can this workload be easily deployed to minikube, EKS, etc?
