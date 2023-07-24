This example shows a best practices deployment in which the brokers are isolated in a separate subnet on a non default
VPC and not allocated public addresses with any external traffic flowing through the internet gateway. The client can be
configured as a proxy to allow access between users and the brokers, or additional security groups can be added to each
port in the ingress/egress rulesets.

This is a reasonable starting point for a production deployment but you may want to explore more or less secure options
depending on the needs of your applications and business -- for example splitting the brokers into a separate VPC or
making the kafka api more accessible to external applications. 
