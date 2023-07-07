This example shows a best practices deployment in which the brokers are isolated in a separate subnet on a non default
VPC and not allocated public addresses with any external traffic flowing through the internet gateway. The client can be
configured as a proxy to allow access between users and the brokers, or additional security groups can be added to each
port in the ingress/egress rulesets.

This does not include a zone or address assignment to hosts, so may not be suitable for production as hosts will have to
be referred to by IP which will be lost on rebuild. This is mostly included for CI testing. 