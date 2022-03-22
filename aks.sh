rg=dev-rg
aks=DevAksCluster
az aks create --resource-group $rg --name $aks --node-count 1 --generate-ssh-keys
az aks install-cli
az aks get-credentials --resource-group $rg --name $aks
