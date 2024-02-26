#
# Make sure to set the environment variables set before running this script.
#
# export GCP_MYSQL_INSTANCE=sqlinstance-sample-mysql
# export GCP_MYSQL_DATABASE=sampledb
# export GCP_MYSQL_USERNAME=userp1f
# export GCP_MYSQL_PASSWORD=$(pwgen -c 16 -n 1)
#
####


echo "Creating table(s)..."
mysql --user=${GCP_MYSQL_USERNAME} --password=${GCP_MYSQL_PASSWORD} --host=${GCP_MYSQL_HOST} ${GCP_MYSQL_DATABASE} < ./customer-table-create.sql

echo "Importing data..."
mysql --user=${GCP_MYSQL_USERNAME} --password=${GCP_MYSQL_PASSWORD} --host=${GCP_MYSQL_HOST} ${GCP_MYSQL_DATABASE}  < ./insert-customer-data.sql

echo "Here is your table:"
mysql --user=${GCP_MYSQL_USERNAME} --password=${GCP_MYSQL_PASSWORD} --host=${GCP_MYSQL_HOST} ${GCP_MYSQL_DATABASE}  -e "use ${GCP_MYSQL_DATABASE}; SELECT * FROM customer;"

