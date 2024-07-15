#!/bin/bash
#
cd tfAviVcenterDc1
terraform init
terraform apply -auto-approve -var-file=avi.json
dc1_jump_ip=$(terraform output -json | jq -r .jump.value)
dc1_jump_private_key=$(terraform output -json | jq -r .jump_private_key.value)
echo "jump IP Dc1 is: ${dc1_jump_ip}"
echo "jump private key Dc1 is: ${dc1_jump_private_key}"
#
cd ../tfAviVcenterDc2
terraform init
terraform apply -auto-approve -var-file=avi.json
dc2_jump_ip=$(terraform output -json | jq -r .jump.value)
dc2_jump_private_key=$(terraform output -json | jq -r .jump_private_key.value)
echo "jump IP Dc2 is: ${dc2_jump_ip}"
echo "jump private key Dc2 is: ${dc2_jump_private_key}"
#
cd ..
scp -o StrictHostKeyChecking=no -i ${dc2_jump_private_key} ubuntu@${dc2_jump_ip}:/home/ubuntu/avi_vcenter_yaml_values.yml ./dc2.yml
scp -o StrictHostKeyChecking=no -i ${dc1_jump_private_key} ./dc2.yml ubuntu@${dc1_jump_ip}:/home/ubuntu/dc2.yml
#
ssh -o StrictHostKeyChecking=no -i ${dc1_jump_private_key} -t ubuntu@${dc1_jump_ip} "/bin/bash /home/ubuntu/alb-ui-api.sh"
#
ssh -o StrictHostKeyChecking=no -i ${dc1_jump_private_key} -t ubuntu@${dc1_jump_ip} "cd /home/ubuntu/alb-ui-api/backend/cert-ca ; /bin/bash cert-ca.sh "internal-private" true true"
#
ssh -o StrictHostKeyChecking=no -i ${dc1_jump_private_key} -t ubuntu@${dc1_jump_ip} "cd /home/ubuntu/alb-ui-api/backend/cert-app ; /bin/bash cert-app.sh "internal-private" true true"