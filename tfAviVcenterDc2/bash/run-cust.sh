directory="tfAviVcenterDc2"
cd ~/${directory}
$(terraform output -json | jq -r .destroy_avi.value)
sleep 5
terraform destroy -auto-approve -var-file=avi.json
directory="tfAviVcenterDc2"
cd ~
rm -fr ${directory}
git clone https://github.com/tacobayle/${directory}
cd ${directory}
TF_VAR_avi_password="6j9w_wMYQ_iWtF"
TF_VAR_ubuntu_password="6j9w_wMYQ_iWtF"
terraform init
terraform apply -auto-approve -var-file=avi.json