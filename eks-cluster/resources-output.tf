#VPC ARN
output "vpc_output_arn" {
   value = "vpc arn = ${aws_vpc.cluster_vpc.arn}"
}

#subnet "subnet name"
output "subnets" {
  value = {for i, subnet in aws_subnet.cluster_subnet: subnet.id => subnet.cidr_block}
  # value = "${aws_subnet.cluster_subnet.id} = ${aws_subnet.cluster_subnet.cidr_block}"
}


# EKS outputs

output "aws_eks_cluster_out" {
  value = aws_eks_cluster.cluster.name
}

# Worker on demand
output "eks_cluster_nodegroup_ondemand_out" {
  value = aws_eks_node_group.eks_cluster_nodegroup_ondemand.node_group_name
}

output "eks_cluster_nodegroup_spot_out" {
  value = aws_eks_node_group.eks_cluster_nodegroup_spot.node_group_name
}

output "access_cluster" {
  value = "To access the cluster, run 'aws eks --region us-east-2 update-kubeconfig --name ${aws_eks_cluster.cluster.name}'"

}

