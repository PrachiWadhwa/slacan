terraform {
  required_providers {
    newrelic = {
      source = "newrelic/newrelic"
      version = "3.40.1"
    }
  }
}
provider "newrelic" {
  # Configuration options
  account_id =  var.account_id
  api_key    =  var.api_key
  region     =  var.region  
}