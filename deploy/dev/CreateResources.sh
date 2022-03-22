rg=$(az group list --query "[?name=='dev-rg'].name" -o tsv)

#Create Resource Group
if [ "$rg" = "dev-rg" ];
then
    az group list -o table
    echo "$rg already exists."
else
    az group create -l eastus -n dev-rg
    rg=$(az group list --query "[?name=='dev-rg'].name" -o tsv)
    az group list -o table
    echo "$rg was successfully created"
fi

#Create SQL Server
sqlserver=$(az sql server list --query "[?name=='luxdevsqlserver'].name" -o tsv)

if [ "$sqlserver" = "luxdevsqlserver" ];
then
    az sql server list -o table
    echo "$sqlserver already exists"
else
    az sql server create -g $rg -l eastus -n luxdevsqlserver -u $SQLSERVERUSERNAME -p $SQLSERVERPASSWORD
    sqlserver=$(az sql server list --query "[?name=='luxdevsqlserver'].name" -o tsv)
    az sql server list -o table
    echo "$sqlserver was successfully created"
fi

#Create ETM SQL Database
sqldatabase_etm=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-ETM-DEV'].name" -o tsv)

if [ "$sqldatabase_etm" = "4PC-Core-ETM-DEV" ];
then
    echo "$sqldatabase_etm already exists"
else
    az sql db create -g $rg -s $sqlserver -n 4PC-Core-ETM-DEV --service-objective Basic
    sqldatabase_etm=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-ETM-DEV'].name" -o tsv)
    az sql db list -g $rg -s $sqlserver -o table
    echo "$sqldatabase_etm was successfully created"
fi

#Create EUS SQL Database
sqldatabase_eus=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-EUS-DEV']".name -o tsv)

if [ "$sqldatabase_eus" = "4PC-Core-EUS-DEV" ];
then
    az sql db list -g $rg -s $sqlserver -o table
    echo "$sqldatabase_eus already exists"
else
    az sql db create -g $rg -s $sqlserver -n 4PC-Core-EUS-DEV --service-objective Basic
    sqldatabase_eus=$(az sql db list -g $rg -s $sqlserver --query "[?name=='4PC-Core-EUS-DEV']".name -o tsv)
    az sql db list -g $rg -s $sqlserver -o table
    echo "$sqldatabase_eus was successfully created"
fi

#Create Storage Account
storageaccount=$(az storage account list -g $rg --query "[?name=='corecontentdev']".name -o tsv)

if [ "$storageaccount" = "corecontentdev" ];
then
    az storage account list -g $rg -o table
    echo "$storageaccount already exists"
else
    az storage account create -n corecontentdev -g $rg -l eastus --sku Standard_LRS
    storageaccount=$(az storage account list -g $rg --query "[?name=='corecontentdev']".name -o tsv)
    az storage account list -g $rg -o table
    echo "$storageaccount was succesfully created"
fi

