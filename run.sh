ARGOCD_EXAMPLE_APP=helm-dependency
ARGOCD_EXAMPLE_APP=helm-guestbook

ARGOCD_EXAMPLE_APP=kustomize-guestbook
ARGOCD_EXAMPLES_ROOT=/Users/solaajayi/experiments/argocd/argocd-example-apps
WATCH_SRC_PATH=${ARGOCD_EXAMPLES_ROOT}/${ARGOCD_EXAMPLE_APP}

# ArgoCD Login
ARGOCD_IP=10.244.0.167
ARGOCD_PORT=8080
ARGOCD_USERNAME=admin
ARGOCD_PASSWORD=
argocd login ${ARGOCD_IP}:${ARGOCD_PORT} --insecure --username ${ARGOCD_USERNAME} --password ${ARGOCD_PASSWORD} 

argocd login ${ARGOCD_IP}:${ARGOCD_PORT} --insecure

# Create Application using YAML
argocd app create ${ARGOCD_EXAMPLE_APP} --file ${WATCH_SRC_PATH}/application.yaml

# Create Application using CLI
argocd app create ${ARGOCD_EXAMPLE_APP} \
--repo https://github.com/shawlz/argocd-example-apps \
--path ${ARGOCD_EXAMPLE_APP} \
--dest-server https://kubernetes.default.svc \
--dest-namespace default

# Sync app from local src
argocd app sync ${ARGOCD_EXAMPLE_APP} --prune --local ${WATCH_SRC_PATH}

# Watch & Sync app from local src
watchmedo shell-command \
    --patterns='*.yaml;*.yml' \
    --recursive \
    --command="argocd app sync ${ARGOCD_EXAMPLE_APP} --prune --local ${WATCH_SRC_PATH}" 

watchmedo log \
    --patterns='*.yaml;*.txt' \
    --ignore-directories \
    --recursive \
    --verbose 

argocd appset create 