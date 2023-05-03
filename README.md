# Ansible ARO

> Deploying ARO with Ansible is dumb.
> The modules are trash and the ARM API is stupid.
> Just run the commands in the Azure Cloud (Bash) Shell - it's not hard at all: https://github.com/tosin2013/openshift-4-deployment-notes/tree/master/aro

---

## Prerequisites

### 1. Enable Needed Resource Providers (Per Subscription)

```bash
az provider register -n Microsoft.RedHatOpenShift --wait
az provider register -n Microsoft.Compute --wait
az provider register -n Microsoft.Storage --wait
az provider register -n Microsoft.Network --wait
az provider register -n Microsoft.Authorization --wait
az provider register -n Microsoft.ContainerRegistry --wait
az provider register -n Microsoft.Quota --wait
az provider register -n Microsoft.Subscription --wait
```

### 2. Increase Quotas [Per Subscription, Per Location]

The basic Azure quota limits are quite low, and are per Subscription - it's a quick process to increase them, [read more about it here](https://docs.microsoft.com/en-us/azure/azure-portal/supportability/per-vm-quota-requests).

There needs to be at least 40 cores available for ARO VMs and by default are of the `standardDSv3Family` and `standardDSv4Family` types unless otherwise specified during cluster creation.

You can list your current quota limits with:

```bash
export AZURE_LOCATION="centralus"

az vm list-usage -l $AZURE_LOCATION \
--query "[?contains(name.value, 'standardDSv3Family')]" \
-o table

az vm list-usage -l $AZURE_LOCATION \
--query "[?contains(name.value, 'standardDSv4Family')]" \
-o table
```

Make sure to increase the ***Total Regional vCPUs***, ***Standard DSv4 Family vCPUs***, and the ***Standard DSv3 Family vCPUs*** - if using other types of machines increase those family groups as well.  You can see price/size comparisons here: https://azure.microsoft.com/en-us/pricing/details/openshift/

Increasing quota limits shouldn't take more than 5-15 minutes and is located under *Subscriptions > Usage and Quotas*.

Note that some times automatic quota increases are denied and a Support Ticket is required - this can take a day so be prepared for that time requirement.

## Development/Hacking

```bash
# Install needed Python modules
python3 -m pip install --upgrade -r requirements.txt

# Install Ansible Collections
ansible-galaxy collection install -r collections/requirements.yml

# Build EE
ansible-builder build -t ansible-aro-ee

# Run EE
ansible-runner run -p create.yml --inventory inventory --container-image quay.io/kenmoini/ansible-aro-ee:latest .
```

```bash
export AZURE_LOCATION="eastus"
export AZURE_SUBSCRIPTION_ID=
export AZURE_CLIENT_ID=
export AZURE_SECRET=
export AZURE_TENANT=
export RESOURCEGROUP=

az login --service-principal -u $AZURE_CLIENT_ID -p $AZURE_SECRET --tenant $AZURE_TENANT

az account set --subscription $SUBSCRIPTION

cat > ~/.azure/credentials <<EOF
[default]
subscription_id=$AZURE_SUBSCRIPTION_ID
client_id=$AZURE_CLIENT_ID
secret=$AZURE_SECRET
tenant=$AZURE_TENANT
EOF

export ANSIBLE_AZURE_AUTH_SOURCE="credential_file"

```