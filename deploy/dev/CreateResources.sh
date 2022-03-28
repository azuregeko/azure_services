#Create Resource Group
echo "Create Resource Group - $ENVIRONMENT"
#rg=$(az group list --query "[?name=='dev-rg'].name" -o tsv)
rg="dev-rg"
rg_exists=$(az group exists -n $rg)

if [ $rg_exists = true ];
then
    echo "$rg already exists."
else
    az group create -l eastus -n dev-rg
    echo "$rg was successfully created"
fi

#Create SQL Server
echo "Create SQL Server - $ENVIRONMENT"
sqlserver=$(az sql server list --query "[?name=='luxdevsqlserver'].name" -o tsv)

if [ "$sqlserver" = "luxdevsqlserver" ];
then
    echo "$sqlserver already exists"
else
    az sql server create -g $rg -l eastus -n luxdevsqlserver -u $SQLSERVERUSERNAME -p $SQLSERVERPASSWORD
    sqlserver=$(az sql server list --query "[?name=='luxdevsqlserver'].name" -o tsv)
    echo "$sqlserver was successfully created"
fi

#Create ETM SQL Database
echo "Create ETM SQL Database - $ENVIRONMENT"

sqldatabase_etm=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-ETM-DEV'].name" -o tsv)

if [ "$sqldatabase_etm" = "4PC-Core-ETM-DEV" ];
then
    echo "$sqldatabase_etm already exists"
else
    az sql db create -g $rg -s $sqlserver -n 4PC-Core-ETM-DEV --service-objective Basic
    sqldatabase_etm=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-ETM-DEV'].name" -o tsv)
    
    echo "$sqldatabase_etm was successfully created"
fi

#Create EUS SQL Database
echo "Create EUS SQL Database - $ENVIRONMENT"
sqldatabase_eus=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-EUS-DEV']".name -o tsv)

if [ "$sqldatabase_eus" = "4PC-Core-EUS-DEV" ];
then
    echo "$sqldatabase_eus already exists"
else
    az sql db create -g $rg -s $sqlserver -n 4PC-Core-EUS-DEV --service-objective Basic
    sqldatabase_eus=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-EUS-DEV']".name -o tsv)
    echo "$sqldatabase_eus was successfully created"
fi



#Create Storage Account
echo "Create Storage Account - $ENVIRONMENT"

storageaccount=$(az storage account list -g $rg --query "[?name=='corecontentdev']".name -o tsv)

if [ "$storageaccount" = "corecontentdev" ];
then
    echo "$storageaccount already exists"
else
    az storage account create -n corecontentdev -g $rg -l eastus --sku Standard_LRS
    storageaccount=$(az storage account list -g $rg --query "[?name=='corecontentdev']".name -o tsv)
    echo "$storageaccount was succesfully created"
fi

az group list -o table
az sql server list -g $rg -o table
az sql db list -g $rg -s $sqlserver -o table
az storage account list -g $rg -o table


#CLEAN UP CREATED RESOURCES
az group delete -g $rg --yes



