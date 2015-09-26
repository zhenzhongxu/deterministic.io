#!/usr/bin/env bash

# your aws deployment info if you choose to use aws provider
export AWS_KEY='your-key'
export AWS_SECRET='your-secret'
export AWS_KEYNAME='your-keyname'
export AWS_KEYPATH='your-keypath'

# required wordpress sql information, recommend to use RDS service
export dbname='your-db-name'
export dbuser='your-db-user'
export dbpassword='your-db-password'
export dbhost='your-db-hostname'
export wp_url='your-wp-url i.e. http://www.abc.com or localhost'
