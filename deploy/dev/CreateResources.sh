#Create Resource Group
echo "Create Resource Group - $ENVIRONMENT"
rg=$(az group list --query "[?name=='dev-rg'].name" -o tsv)

if [ "$rg" = "dev-rg" ];
then
    echo "$rg already exists."
else
    az group create -l eastus -n dev-rg
    rg=$(az group list --query "[?name=='dev-rg'].name" -o tsv)
    echo "$rg was successfully created"
fi

az group list -o table

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

az sql server list -o table

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

az sql db list -g $rg -s $sqlserver -o table

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

az sql db list -g $rg -s $sqlserver -o table

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

az storage account list -g $rg -o table


