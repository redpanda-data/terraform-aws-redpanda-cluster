This example contains a cluster that uses the default VPC and subnet. It has custom security group configuration that
limits access to the brokers to the client node. Additional security groups can be granted access by adding them to the
ingress/egress security groups list for each port.

While this is a reasonably secure model, the use of the default VPC is not recommended. 