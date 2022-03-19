#!/bin.bash

me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

display_usage() { 
	echo "Example of usage:" 
	echo -e "bash $me -n aks-security2022 -g aks-rg  -i \"ingress-nginx,kube-node-lease,kube-public,kube-system,calico-system,tigera-operator,gatekeeper-system\" -l \"logs/aks.log\" " 
	} 
    
while getopts n:g:i:l option
do
case "${option}"
in
n) AKS_NAME=${OPTARG};;
g) AKS_RG=${OPTARG};;
i) AKS_NAMESPACES=${OPTARG};;
l) LOG_FILE=${OPTARG};;
esac
done


if [ -z "$AKS_NAME" ]
then
      echo "AKS_NAME is empty"
	  display_usage
	  exit 1
else
	  echo "AKS_NAME: $AKS_NAME"
fi

if [ -z "$AKS_RG" ]
then
      echo "AKS_RG is empty"
	  display_usage
	  exit 1
else
	  echo "AKS_RG: $AKS_RG"
fi

if [ -z "$AKS_NAMESPACES" ]
then
      echo "AKS_NAMESPACES is empty"
	  display_usage
	  exit 1
else
	  echo "AKS_NAMESPACES: $AKS_NAMESPACES" 
fi

if [ -z "$LOG_FILE" ]
then
      echo "LOG_FILE is empty"
	  display_usage
#	  exit 1
else
	  echo "LOG_FILE: $LOG_FILE"
fi

set -u  # Treat unset variables as an error when substituting
set -e # Exit immediately if a command exits with a non-zero status.



command='az aks get-credentials -g ${AKS_RG} -n ${AKS_NAME} --admin --overwrite-existing'
echo ${command}
eval ${command}

command='aks-hc check all -g ${AKS_RG} -n ${AKS_NAME} -i ${AKS_NAMESPACES} -v >> logs/aks.log' 
echo ${command}
eval ${command}
