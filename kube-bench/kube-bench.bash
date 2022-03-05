#!/bin/bash


export AnException=100

function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function throw()
{
    exit $1
}

function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}

function throwErrors()
{
    set -e
}

function ignoreErrors()
{
    set +e
}


me="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"

display_usage() { 
	echo "Example of usage:"  
    echo -e "bash $me  -n kube-system -l kube-bench.log -j kube-bench -t aks-1.0"
	} 


containsElement () {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 100
}

target=("master" "etcd" "policies" "node" "aks-1.0")


while getopts l:n:j:t: option
do
case "${option}"
in
l) LOG_FILE=${OPTARG};;
n) NAMESPACE=${OPTARG};;
j) JOB_NAME=${OPTARG};;
t) TARGET=${OPTARG};;
esac
done


if [ -z "$JOB_NAME" ]
then
      echo "JOB_NAME is empty"
	  display_usage
	  exit 1
else
      echo "JOB_NAME :$JOB_NAME"
fi


if [ -z "$LOG_FILE" ]
then
    echo "LOG_FILE is empty"
	  display_usage
	  exit 1
else
      echo "LOG_FILE :$LOG_FILE"
fi


if [ -z "$NAMESPACE" ]
then
    echo "NAMESPACE is empty"
	  display_usage
	  exit 1
else
      echo "NAMESPACE :$NAMESPACE"
fi

set -u
set -e
set -o pipefail

shopt -s expand_aliases

if [ -z "$TARGET" ]
then
    echo "TARGET is empty"
	  display_usage
	  exit 1
else
  try
  (
     echo "TARGET :$TARGET"
     containsElement $TARGET "${target[@]}" && throw $AnException
     error_code=$?
     echo "Error code: $error_code"
     if [ $error_code -gt 0 ]
     then 
       echo "You should use one of the values for target: ${target[@]}"
       exit 1
     fi
  )

catch || {
    # now you can handle
    case $ex_code in
        $AnException)
            echo "AnException was thrown"
        ;;
        *)
            echo "An unexpected exception was thrown"

            throw $ex_code # you can rethrow the "exception" causing the script to exit if not caught
        ;;
    esac
} 

fi

kubectl -n ${NAMESPACE} get job/${JOB_NAME} --ignore-not-found

# remove existing job 

kubectl -n ${NAMESPACE} delete job/${JOB_NAME} --ignore-not-found

cat <<EOF | kubectl -n ${NAMESPACE} apply -f -
---
apiVersion: batch/v1
kind: Job
metadata:
  name: ${JOB_NAME}
spec:
  template:
    metadata:
      labels:
        app: kube-bench
    spec:
      hostPID: true
      nodeSelector:
        node-role.kubernetes.io/master: ""
      tolerations:
      - key: "node-role.kubernetes.io/master"
        value: ""
        effect: "NoSchedule"
      containers:
        - name: kube-bench
          image: aquasec/kube-bench:latest
          command: ["kube-bench", "run", "--targets", "node", "--benchmark", "${TARGET}"]
          volumeMounts:
            - name: var-lib-etcd
              mountPath: /var/lib/etcd
              readOnly: true
            - name: var-lib-kubelet
              mountPath: /var/lib/kubelet
              readOnly: true
            - name: etc-systemd
              mountPath: /etc/systemd
              readOnly: true
            - name: etc-kubernetes
              mountPath: /etc/kubernetes
              readOnly: true
              # /usr/local/mount-from-host/bin is mounted to access kubectl / kubelet, for auto-detecting the Kubernetes version.
              # You can omit this mount if you specify --version as part of the command.
            - name: usr-bin
              mountPath: /usr/local/mount-from-host/bin
              readOnly: true
      restartPolicy: Never
      volumes:
        - name: var-lib-etcd
          hostPath:
            path: "/var/lib/etcd"
        - name: var-lib-kubelet
          hostPath:
            path: "/var/lib/kubelet"
        - name: etc-systemd
          hostPath:
            path: "/etc/systemd"
        - name: etc-kubernetes
          hostPath:
            path: "/etc/kubernetes"
        - name: usr-bin
          hostPath:
            path: "/usr/bin"
EOF



# check job condition
#kubectl wait --for=condition=completed job  ${JOB_NAME} -n ${NAMESPACE}

echo "waiting for kube-bench job to be comleted..."
while [[ $(kubectl get job  ${JOB_NAME} -n ${NAMESPACE} -o 'jsonpath={..status.conditions[?(@.type=="Complete")].status}') != "True" ]]; do echo "waiting for job" && sleep 1; done
echo "job is comleted"


kubectl -n ${NAMESPACE} logs job/${JOB_NAME} > $LOG_FILE

cat $LOG_FILE