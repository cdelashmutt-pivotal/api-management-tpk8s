#TODO
Unseal, if not using Dev server.
Need startup job that does the steps below:
kubectl -n vault exec -it vault-0 -- /bin/sh
vault secrets enable -path=api-portal-keys kv-v2
( \
  cat << EOF \
path "api-portal-keys/data/*" { \
capabilities = ["create", "read", "update", "delete", "list"] \
} \
path "api-portal-keys/metadata/*" { \
capabilities = ["list", "delete"] \
} \
EOF \
) | vault policy write api-portal-policy -

(\
cat << EOF\
  path "api-portal-keys/data/*" {\
    capabilities = ["read"]\
  }\
  path "api-portal-keys/metadata/*" {\
    capabilities = ["list"]\
  }\
EOF\
) | vault policy write gateway-policy -\

vault auth enable kubernetes

vault write auth/kubernetes/config \
 token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
 kubernetes_host="https://$KUBERNETES_PORT_443_TCP_ADDR:443" \
 kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

vault write auth/kubernetes/role/api-portal-role \
 bound_service_account_names=api-portal-service-account \
 bound_service_account_namespaces=api-portal \
 policies=api-portal-policy \
 ttl=24h

vault write auth/kubernetes/role/gateway-role \
 bound_service_account_names=spring-cloud-gateway-svc-acc \
 bound_service_account_namespaces=* \
 policies=gateway-policy \
 ttl=24h