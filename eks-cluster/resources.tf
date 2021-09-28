/**
**   VPC definition with all the necessary resources to make it functionnal.
**/
resource "aws_vpc" "cluster_vpc"{
  cidr_block = cidrsubnet("10.0.0.0/16",0,0)
  tags={
    Name=var.vpc_name
    Description = "The cluster name"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_internet_gateway" "cluster_internet_gateway" {
  vpc_id = aws_vpc.cluster_vpc.id
  tags = { 
    Name = "cluster_igw"
  }
}

resource "aws_route_table" "cluster_rt" {
  vpc_id = aws_vpc.cluster_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cluster_internet_gateway.id
  }
  tags = {
    Name = "cluster_rt"
  }
}

resource "aws_main_route_table_association" "cluster_rt_main" {
  vpc_id         = aws_vpc.cluster_vpc.id
  route_table_id = aws_route_table.cluster_rt.id
}

resource "aws_subnet" "cluster_subnet"{
  count             = length(data.aws_availability_zones.available.names)
  vpc_id = aws_vpc.cluster_vpc.id
  cidr_block = cidrsubnet(aws_vpc.cluster_vpc.cidr_block, 8, count.index)
  # for_each = {us-east-1a=cidrsubnet("172.20.0.0/16",8,10),us-east-1b=cidrsubnet("172.20.0.0/16",8,20),us-east-1c=cidrsubnet("172.20.0.0/16",8,30)}
  availability_zone = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch= true
  tags={
    Name="cluster_subnet_${count.index}"
  }
}


/**
**   EKS definition with all the necessary resources to make it functionnal.
**/

# IAM role
resource "aws_iam_role" "eks_cluster_role" {
  name = "eks_cluster_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "eks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}


data "aws_iam_policy" "eks_cluster_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


resource "aws_iam_role_policy_attachment" "eks_cluster_attach_policy_to_role" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = data.aws_iam_policy.eks_cluster_policy.arn
}


# Create k8s clusster
resource "aws_eks_cluster" "cluster" {
  name     = "eks_cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = data.aws_subnet_ids.cluster_subnet_ids.ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_attach_policy_to_role,
    aws_subnet.cluster_subnet
  ]

}



#worker's node groups IAM ROLE
resource "aws_iam_role" "eks_cluster_worker_role" {
  name = "eks_cluster_worker_role"
  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ec2.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": "1"
   }
 ]
}
EOF
}


resource "aws_iam_role_policy_attachment" "eks_cluster_attach_policy_to_worker_role" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ])


  role       = aws_iam_role.eks_cluster_worker_role.name
  policy_arn = each.value
}

# worker's node group
resource "aws_eks_node_group" "eks_cluster_nodegroup_ondemand" {
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = "eks_cluster_nodegroup_ondemand"
  node_role_arn   = aws_iam_role.eks_cluster_worker_role.arn
  subnet_ids      = data.aws_subnet_ids.cluster_subnet_ids.ids

  labels = {
    type_of_nodegroup = "on_demand_untainted"
  }

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 2
  }

  # taint {
  #   key = "key1"
  #   value = "value1"
  #   effect = "NO_SCHEDULE"
  # }

  instance_types = [ "t2.micro", "t3.micro" ]

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_attach_policy_to_worker_role
  ]
}



# spot instance worker node
# resource "aws_eks_node_group" "eks_cluster_nodegroup_spot" {
#   cluster_name    = aws_eks_cluster.cluster.name
#   node_group_name = "eks_cluster_nodegroup_spot"
#   node_role_arn   = aws_iam_role.eks_cluster_worker_role.arn
#   subnet_ids      = data.aws_subnet_ids.cluster_subnet_ids.ids
#   capacity_type = "SPOT"
#   scaling_config {
#     desired_size = 1
#     max_size     = 4
#     min_size     = 1
#   }

#   # taint {
#   #   key = "key1"
#   #   value = "value1"
#   #   effect = "NO_SCHEDULE"
#   # }

#   instance_types = [ "t2.micro", "t3.micro" ]
   
#   labels = {
#     type_of_nodegroup = "spot_untainted"
  

#   }

#   depends_on = [
#     aws_iam_role_policy_attachment.eks_cluster_attach_policy_to_worker_role
#   ]
# }



