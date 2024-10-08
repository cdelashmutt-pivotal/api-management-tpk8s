#!/bin/bash

VERSION=0.0.7

curl -L -o jar/tanzu-local-authorization-server-$VERSION.jar -u "$SPRING_ENTERPRISE_USERNAME:$SPRING_ENTERPRISE_TOKEN" https://packages.broadcom.com/artifactory/spring-enterprise/com/vmware/tanzu/spring/tanzu-local-authorization-server/$VERSION/tanzu-local-authorization-server-$VERSION.jar