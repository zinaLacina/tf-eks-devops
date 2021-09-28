# tf-k8s-devops
This project is simple example of how to create a eks cluster using terraform. 
Also how to mix spot instances and on-demand instances to save money.
[The nginx fiile](nginx.yaml) is an example of service and deployment that get unevenly distributed accross nodes, for high availability.
For k8s version under 18, you will have to mix node taint, pod affinity and node selector to be able to accomplish the same feature.