#!/bin.bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

display_usage() { 
	echo "Example of usage:" 
	echo -e "bash $me aks-hc check all -n <cluster name> -g <resource group>  -i ingress-nginx,kube-node-lease,kube-public,kube-system" 
	} 
    
while getopts n:g:i: option
do
case "${option}"
in
n) AKS_NAME=${OPTARG};;
g) AKS_RG=${OPTARG};;
i) AKS_NAMESPACES=${OPTARG};;
esac
done


if [ -z "$AKS_NAME" ]
then
      echo "\$AKS_NAME is empty"
	  display_usage
	  exit 1
else
      echo "\$AKS_NAME is NOT empty"
fi

if [ -z "$AKS_RG" ]
then
      echo "\$AKS_RG is empty"
	  display_usage
	  exit 1
else
      echo "\$AKS_RG is NOT empty"
fi

if [ -z "$AKS_NAMESPACES" ]
then
      echo "\$AKS_NAMESPACE is empty"
	  display_usage
	  exit 1
else
      echo "\$AKS_NAMESPACE is NOT empty"
fi

set -u  # Treat unset variables as an error when substituting
set -e # Exit immediately if a command exits with a non-zero status.

command='aks-hc check all -g ${AKS_RG} -n ${AKS_NAME} -i ${AKS_NAMESPACES}' 
echo ${command}
eval ${command}
