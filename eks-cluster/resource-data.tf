# Availabilty 
data "aws_availability_zones" "available" {
  state = "available"
}

# custom subnet data
data "aws_subnet_ids" "cluster_subnet_ids" {
  vpc_id = aws_vpc.cluster_vpc.id
  depends_on = [ aws_subnet.cluster_subnet ]
}