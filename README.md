# mysql-openshift-ephemeral
Demo: Creating an applicatipon that uses an MySQL instance running on GCP.

The original purpose of the repo from which I forked this, was to accompany a blog post at developers.redhat.com that instructs how to create an ephemeral MySQL instance in OpenShift 4.x. I have modified the content and instructions to work with an external MySQL instance.

**This is not a best practice nor is it a recommendation for how to set this up in any production system.**

Like everything else we do at Red Hat, it's open source and open to pull requests.

*Note:* The code in this repo contain the creation of the database the the code for the app. Because of this, the instructions will not go in to any detail on how to set up the OSD cluster or how to configure the Google Config Connector. These steps are there just for reference.

## Create an OSD cluster
https://docs.openshift.com/dedicated/osd_install_access_delete_cluster/creating-a-gcp-cluster.html
 
## Install google config connector
https://cloud.google.com/config-connector/docs/how-to/install-other-kubernetes

## Create a managed SQL instance
https://cloud.google.com/sdk/gcloud/reference/sql

## Populate database  

**NOTE that you must change the user and password values in the following script before running it.**

`$PROJECT-HOME/scripts/create-customer.sh`  

## Create a new project
`oc new-project google-test`

## Create the getCustomer service
#### Note: The variables 'MYSQL_USER' and 'MYSQL_PASSWORD' must be the credentials that you reate in your managed SQL in GCP, youare determined by the values returned after you create the ephemeral MySQL application, above.  

```
oc new-app https://github.com/redhat-developer-demos/mysql-openshift-ephemeral.git \
  --context-dir=src/getCustomer \
  --name getcustomer \
  -e MYSQL_HOST=${GCP_MYSQL_HOST} \
  -e MYSQL_DATABASE=${GCP_MYSQL_DATABASE} \
  -e MYSQL_USER=${GCP_MYSQL_USER} \
  -e MYSQL_PASSWORD=${GCP_MYSQL_PASSWORD}
```

## Create the getCustomerSummaryList service
#### Note: The variables 'MYSQL_USERNAME' and 'MYSQL_PASSWORD' are determined by the values that you created you manageds SQL instance with and must the same that you use when running the create_customer.sh script above.  

```
oc new-app https://github.com/redhat-developer-demos/mysql-openshift-ephemeral.git \
  --context-dir=src/getCustomerSummaryList --name getcustomersummarylist \
  -e MYSQL_HOST=${GCP_MYSQL_HOST} \ 
  -e MYSQL_DATABASE=${GCP_MYSQL_DATABASE} \ 
  -e MYSQL_USER=${GCP_MYSQL_USER} \
  -e MYSQL_PASSWORD=${GCP_MYSQ_USER}
```

## Create the service "mvccustomer"
This will pull a Linux image from a registry. This is being done to demonstrate the versatility of the OpenShift application build feature.

```
oc new-app --name mvccustomer \ 
  --docker-image=quay.io/donschenck/mvccustomer:latest \
  -e GET_CUSTOMER_SUMMARY_LIST_URI="http://getcustomersummarylist:8080/customers" \
  -e GET_CUSTOMER_URI="http://getcustomer:8080/customer"
```

## Expose the mvccustomer web site
`oc expose service mvccustomer --insecure-skip-tls-verify=false`

## Test it
Get the route, then open it in your browser:  
`oc get routes`


### END ###
