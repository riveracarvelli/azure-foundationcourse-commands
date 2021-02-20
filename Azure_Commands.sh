#This script has commands for the following Azure categories:
#
#   1. Virtual Machines
#   2. Web Apps
#   3. Azure SQL
#   4. BLOB Storage
#   5. Resource Group


#1. Virtual Machines - START


#Grab the IP addresses for a particular Azure VM 
az vm list-ip-addresses -g <RESOURCE-GROUP> -n <VIRTUAL-MACHINE-NAME>
#----------------------------------------------------------------------


#Create a VM
az vm create \
   --resource-group "resource-group-west" \
   --name "linux-vm-west" \
   --location "westus2" \
   --image "UbuntuLTS" \
   --size "Standard_B1ls" \
   --admin-username "udacityadmin" \
   --generate-ssh-keys \
   --verbose

#NOTE: If we don't pass a location, it defaults to the location of the resource group.
#-------------------------------------------------------------------------------------


#Open a port on a VM
az vm open-port \
    --port "80" \
    --resource-group "resource-group-west" \
    --name "linux-vm-west"
#----------------------------------------------------------------------

#Virtual Machines - END



#2. Web Apps - START

#Create new web app
#NOTE: The command is required to run from the folder where the code is present. Current support includes Node, Python, 
#.NET Core and ASP.NET. Node, Python apps are created as Linux apps. .Net Core, ASP.NET, and static HTML apps are 
#created as Windows apps. Append the html flag to deploy as a static HTML app.

az webapp up \
 --resource-group resource-group-west \
 --name hello-world1234 \
 --sku F1 \
 --verbose


#Update code in existing web app
#NOTE: Same as the Create new web app
az webapp up \
 --name hello-world1234 \
 --verbose


#Delete an app service
az webapp delete \
    --name hello-world1234 \
    --resource-group resource-group-west


#Delete a service plan
az appservice plan delete \
    --name [App Service Plan Name] \
    --resource-group resource-group-west


#Web Apps - END


#3. Azure SQL - START
#NOTE: The following commands need to be done so that a database can be created on azure

#Create an SQL Server to host the database that you are going to create
az sql server create \
--admin-user udacityadmin \
--admin-password p@ssword1234 \
--name hello-world-server \
--resource-group resource-group-west \
--location westus2 \
--enable-public-network true \
--verbose


#Create a firewall rule so that azure services and resources can access the SQL server we created
az sql server firewall-rule create \
-g resource-group-west \
-s hello-world-server \
-n azureaccess \
--start-ip-address 0.0.0.0 \
--end-ip-address 0.0.0.0 \
--verbose


#Create a firewall rule so that your computer can access the server
#NOTE: You will need your public ip for this command. 
#Linux and Mac: curl ifconfig.me
#Windows: ipconfig

az sql server firewall-rule create \
-g resource-group-west \
-s hello-world-server \
-n clientip \
--start-ip-address <PUBLIC-IP-ADDRESS> \
--end-ip-address <PUBLIC_IP_ADDRESS> \
--verbose


#Create the database
#NOTE: It's important to add the tier argument as the default tier is a higher level
az sql db create \
--name hello-world-db \
--resource-group resource-group-west \
--server hello-world-server \
--tier Basic \ 
--verbose


#Delete DB
az sql db delete \
--name hello-world-db \
--resource-group resource-group-west \
--server hello-world-server \
--verbose


#Delete the SQL Server
az sql server delete \
--name hello-world-server \
--resource-group resource-group-west \
--verbose


#Azure SQL - END


#4. BLOB Storage - START

#Create storage account
az storage account create \
 --name helloworld12345 \
 --resource-group resource-group-west \
 --location westus2

#The storage will default to general purpose V2 and the access tier cannot be set, so it will default to hot.


#Create container
az storage container create \
 --account-name helloworld12345 \
 --name images \
 --auth-mode login \
 --public-access container

#BLOB Storage - END


#5.Resource Group-START

#Delete a Resource Group
az group delete -n resource-group-west

#Resource Group-END
