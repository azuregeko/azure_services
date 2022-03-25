rg="aks-management"
aks=$(az aks list -g $rg --query "[?name=='acrEssiLux'].name" -o tsv)

#Create ACR - DEV
#acrId=$(az acr show -g $rg -n acrEssiLux --query id -o tsv)

acrId=$(az acr check-name -n acrEssiLux --query nameAvailable -o tsv)
if [ $acrId = true ];
then
    echo "$acrId already exists!"
else
    az deployment group create -g $rg --template-file ./azure-infra.bicep
    az acr create -g $rg -n acrEssiLux --sku Basic -l eastus --allow-trusted-services true
    acrName='acrEssiLux'
    echo "$acrId is successfully created"
fi

#Get ACR id
azureAcrId=$(az acr show -g $rg -n $acrId --query id -o tsv)

#Create AKS - DEV

if [ "$aks" = "AKS-ESSLUX" ];
then
    echo "$aks - kubernetes service already exists"
else
    az aks create -g $rg -n AKS-ESSILUX --enable-cluster-autoscaler --min-count 2 --max-count 5 --attach-acr $azureAcrId
    echo "Creating $aks..."
fi


#Check AKS and ACR Connection
acrLoginServer=$(az acr show -g $rg -n acrEssiLux --query loginServer -o tsv)
az aks check-acr -g $rg -n $aks --acr $acrLoginServer




