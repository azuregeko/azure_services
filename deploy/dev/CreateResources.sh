rg=$(az group list --query "[?name=='dev-rg'].name" -o tsv)

if [ "$rg" = "dev-rg" ];
then
    az group list -o table
    echo "$rg is already exists"
else
    az group create -l eastus -n dev-rg
    rg=$(az group list --query "[?name=='dev-rg'].name" -o tsv)
    az group list -o table
    echo "$rg was successfully created"
fi

sqlserver=$(az sql server list --query "[?name=='luxdevsqlserver'].name" -o tsv)

if [ "$sqlserver" = "luxdevsqlserver" ];
then
    az sql server list -o table
    echo "$sqlserver already exists"
else
    az sql server create -l eastus -n luxdevsqlserver
    sqlserver=$(az sql server list --query "[?name=='luxdevsqlserver'].name" -o tsv)
    az sql server list -o table
    echo "$sqlserver was successfully created"

sqldatabase_etm=$(az sql db list -r $rg -s $sqlserver --query "[?name=='sqldatabase_etm'].name" -o tsv)

if [ "$sqldatabase_etm" = "sqldatabase_etm" ];
then
    echo "$sqldatabase_etm already exists"
else
    az sql server create -g $rg -s $sqlserver -n etm-dev Basic
    sqldatabase_etm=$(az sql db list -r $rg -s $sqlserver --query "[?name=='sqldatabase_etm'].name" -o tsv)
    az sql db list -r $rg -s $sqlserver --query "[?name=='sqldatabase_etm'].name" -o tsv
    echo "$sqldatabase_etm was successfully created"
