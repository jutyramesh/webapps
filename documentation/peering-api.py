# Provided by Nicholas Barber

# Must login to the container to run the following script 
# az login
# az container exec --exec-command '/bin/sh' --ids <resource id of the container>
# run python3 to open the python command 
import json
import requests

# Get access token with the following command ACCESS_TOKEN=$(az account get-access-token | jq -r .accessToken)
access_token = <access_token>

headers = {

'Content-type': 'application/json',

'Authorization': 'Bearer {access_token}'.format(access_token=access_token)

}

url = "https://ccp-peering-api.rpu-nprod-infra-svcs-eastus2-ase-01.appserviceenvironment.net/api/networks/peer"

body = {
# update the spoke vnet resource ID 
"resource_id": "/subscriptions/<subID>/resourceGroups/<RG>/providers/Microsoft.Network/virtualNetworks/<vnetname>"

}

requests.post(url=url, headers=headers, data=json.dumps(body))