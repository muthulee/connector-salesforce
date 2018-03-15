# Salesforce Connector

## Salesforce
Salesforce is the world’s #1 CRM platform that employees can access entirely over the Internet (https://www.salesforce.com)

The Salesforce connector which is implemented in ballerina allows you to access the Salesforce REST API. ClientConnector covers the basic functionalities as well as the high level functionalities of the REST API. (https://developer.salesforce.com/page/REST_API)

Ballerina is a strong and flexible language. Also it is JSON friendly. It provides an integration tool which can be used to integrate the Salesforce API with other endpoints.  It is easy to write programs for the Salesforce API by having a connector for Salesforce. Therefor the Salesforce connector allows you to access the Salesforce REST API through Ballerina easily. 

Salesforcerest connector actions are being invoked by a ballerina main function. The following section provides you the details on how to use Ballerina Salesforce connector.

## Compatibility

| Language Version  | Connector Version | API Version |
| ------------------| ------------------| ------------|
|     0.964.0       |       0.964       |   v37.0     |


## Getting started

1. Download the Ballerina tool 0.964.0 distribution by navigating to https://ballerinalang.org/downloads/
2. Navigate to the [pull request](https://github.com/wso2-ballerina/package-oauth2/pull/12) or [repository](https://github.com/keerthu/package-oauth2/tree/6622641069a7dcb9628ccdc62b8072a2872b0d4f) Download, build the POM and copy oauth2 jar file into    the <ballerina-tools>/bre/lib folder.
3. Clone the repository by running the following command
   git clone https://github.com/erandiganepola/connector-salesforce.git
   Import the package to your ballerina project.

### Prerequisites
Create a Salesforce organization, create a connected app by visiting Salesforce and obtain the following parameters:
* Client Id
* Client Secret
* Access Token
* Refresh Token
* Api Instance
* Api Version
* Refresh endpoint
 * Refresh endpoint :- Sandbox Organization - https://test.salesforce.com/services/oauth2/token Other Organization - https://login.salesforce.com/services/oauth2/token

IMPORTANT This access token and refresh token can be used to make API requests on your own account's behalf. Do not share your access token, client secret with anyone.

### Working with Salesforce REST connector actions

[describeAvailableObjects()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_describeGlobal.htm)
Lists the available objects and their metadata for your organization’s data

[describeSObject()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_describe.htm)
Completely describes the individual metadata at all levels for the specified object

[getAvailableApiVersions()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_versions.htm?search_text=error)
Lists summary information about each REST API version currently available

[getOrganizationLimits()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_limits.htm)
Lists limits information for your organization

[getResourcesByApiVersion()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_discoveryresource.htm)
Lists the resources available for the specified API version

[getSObjectBasicInfo()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_basic_info.htm)
Describes the individual metadata for the specified object

[getDeletedRecords()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_get_deleted.htm?search_text=deleted)
Retrieves the list of individual records that have been deleted within the given timespan for the specified object

[getUpdatedRecords()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_getupdated.htm?search_text=updated)
Retrieves the list of individual records that have been updated (added or changed) within the given timespan for the specified object

[sObjectPlatformAction()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_sobject_platformaction.htm)
Query for actions displayed in the UI, given a user, a context, device format, and a record ID

[getRecord()](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/using_resources_working_with_records.htm)
Accesses records based on the specified object ID

[getRecordByExternalId](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/using_resources_retrieve_with_externalid.htm?search_text=external%20ID)
Creates new records or updates existing records (upserts records) based on the value of a specified external ID field

[explainQueryOrReportOrListview](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_query_explain.htm?search_text=explain)
Get feedback on how Salesforce will execute your list view

[query](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_query.htm)
Executes the specified SOQL query

[getAllQueries](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/resources_queryall.htm?search_text=updated)
QueryAll will return records that have been deleted because of a merge or delete, archived Task and Event records

nextQueryResult
If the queryAll results are too large, retrieve the next batch of results

[createRecord](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_sobject_create.htm)
Creates new records

[createMultipleRecords](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_composite_sobject_tree_flat.htm)
Create multiple records

[deleteRecord](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_delete_record.htm)
Deletes existing record

[getfieldValuesFromSObjectRecord](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_get_field_values.htm)
Retrieve field values from a record

[getFieldValuesFromExternalObjectRecord](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_get_field_values_external_object.htm)
Retrieve field values from an external record

[updateRecord](https://developer.salesforce.com/docs/atlas.en-us.api_rest.meta/api_rest/dome_update_fields.htm)
Updates an existing record
