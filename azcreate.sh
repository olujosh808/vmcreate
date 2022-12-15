#!/bin/bash
 
#Login Azure 
az login 
 
#create a resource group 
az group create --location canadaeast --name devopstest 
 
#Create a Public IP 
#az network  public-ip create --name linuxvm-ip --resource-group devopstest --location canadaeast 

az network public-ip create --resource-group devopstest --name linuxvmip --version IPv4 --sku Standard --zone 1 2 3
 
#Create VNET 
az network vnet create --name vm-test --resource-group devopstest --address-prefixes 10.10.0.0/16 --location canadaeast --subnet-name vmsubnet --subnet-prefix 10.10.1.0/24
 
#Create Network Security Group
az network nsg create --name vmsubnet --resource-group devopstest --location canadaeast 
 
#Associate the NSG to the subnet 
az network vnet subnet update --name vmsubnet --resource-group devopstest --vnet-name vm-test --network-security-group vmsubnet 
 
#Create NIC
az network nic create --resource-group devopstest --name linuxvm-nic --subnet vmsubnet --vnet-name vm-test --location canadaeast --public-ip-address linuxvm-ip 
 
#Create a VM
az vm create --name linuxvm --resource-group devopstest --admin-username localadmin --admin-password kasunraj@1990 --image RHEL --authentication-type password --nics linuxvm-nic  --size Standard_DS1 --location canadaeast
 
#Open port 22 for SSH
az vm open-port --name linuxvm --port 22 --resource-group devopstest --apply-to-subnet --priority 1000 
#OR
# az network nsg rule create --name SSH --nsg-name vmsubnet --priority 1100 --resource-group devopstest --source-address-prefix * --source-port-range * --destination-address-prefix * --destination-port-range 22 --protocol Tcp