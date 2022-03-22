testing="123"
echo "$testing is found"
az group list -o table

rg=$(az group list --query "[?name=='react-dev'].name" -o tsv)


if [ "$rg" = "react-dev" ];
then
    echo "$rg is exists"
else
    echo "$rg does not exists"
fi
# then
#     echo "resource group $rg exists"
# else
#     az group create -l eastus2 -n azure-cli-actions
#     rg_created=$(az group list --query "[?name=='azure-cli-actions'].name" -o tsv)
#     echo "resource group $rg_created was created"
