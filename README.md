<h2>This code creates the following items:</h2>
<ol>
<li>VPC</li>
<li>Public networks in every availability zone of the region</li>
<li>Private networks in every availability zone of the region</li>
<li>Network gateways and route tables for public and private networks</li>
<li>Separate security groups for every autoscaling group</li>
<li>ELB in public subnet</li>
<li>Autoscaling group ith instances to be launched in the private subnets</li>
</ol>
<h2>TBD:</h2>
<ol>
<li>S3 bucket for assets</li>
<li>IAM instance profile that can read and write files at assets s3 bucket</li>
<li>RDS</li>
<li>Elasticache redis</li>
</ol>
<h2>Here is what I'm thinking of:</h2>
<img src="mageto_aws_infrastructure.png"></img>
