#!/bin/bash
#
cd tfAviVcenterDc1
terraform output -json | jq -c -r .destroy.value | tee destroy.sh
/bin/bash destroy.sh
#
cd ../tfAviVcenterDc2
terraform output -json | jq -c -r .destroy.value | tee destroy.sh
/bin/bash destroy.sh