package samples.wso2.salesforce;

import ballerina.io;
import src.wso2.salesforce;
import ballerina.net.http;

http:HttpConnectorError e;
http:InResponse response = {};
error err = {};

@Description {value:"Sample consists of main() to test salesforce ClientConnector"}
@Param {value:"baseUrl: The endpoint base url"}
@Param {value:"accessToken: The access token of the account"}
@Param {value:"clientId: The client Id of the account"}
@Param {value:"clientSecret: The client secret of the account"}
@Param {value:"refreshToken: The refresh token of the account"}
@Param {value:"refreshTokenEndpoint: The refresh token endpoint url"}
@Param {value:"refreshTokenPath: "}

string baseUrl = "https://wso2--wsbox.cs8.my.salesforce.com";
string accessToken = "00DL0000002ASPS!ASAAQHyEs5qD9BzTEevUWAIUOjGh0e9zyVIojgS1dLwNXhlMBXGre8IwNoruuV6joCjAR0qG1B8KhNOxYSczwOuRmCEQU6LG";
string clientId = "3MVG9MHOv_bskkhSA6dmoQao1M5bAQdCQ1ePbHYQKaoldqFSas7uechL0yHewu1QvISJZi2deUh5FvwMseYoF";
string clientSecret = "1164810542004702763";
string refreshToken = "5Aep86161DM2BuiV6zOy.J2C.tQMhSDLfkeFVGqMEInbvqLfxzBz58_XPXLUMpHViE8EqTjdV7pvnI1xq8pMfOA";
string refreshTokenEndpoint = "https://test.salesforce.com";
string refreshTokenPath = "/services/oauth2/token";
string apiVersion = "v37.0";
string startDateAndTime = "2018-01-07T07:10:38+00:00";
string endDateAndTime = "2018-02-07T07:10:38+00:00";
string sampleSObject = "Account";
string namedLayoutInfo = "";

public function main (string[] args) {

    //calling the ClientConnector and creating the instance
    endpoint<salesforce:ClientConnector> testSalesforce {
        create salesforce:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath, apiVersion);
    }
    http:HttpConnectorError e = {};
    error err = {};
    json jsonResponse;

    /////////////////////////////////////////////////////////////////////////////////////////////
    //                                  calling the connector actions                         //
    ////////////////////////////////////////////////////////////////////////////////////////////

    salesforce:ApiVersion[] apiVersions = [];
    apiVersions, err = testSalesforce.listAvailableApiVersions();
    io:println("------------------------MAIN METHOD: listAvailableApiVersions()----------------------");

    //calling the connector action listResouresByApiVersion()
    jsonResponse, err = testSalesforce.listResourcesByApiVersion();
    io:println("------------------------MAIN METHOD: listResourcesByApiVersion()---------------------");
    //io:println(jsonResponse);

    //calling the connector action listOrganizationLimits()
    jsonResponse, err = testSalesforce.listOrganizationLimits();
    io:println("------------------------MAIN METHOD: listOrganizationLimits()-------------------------");
    //io:println(jsonResponse);

    //calling the connector action describeGlobal()
    jsonResponse, err = testSalesforce.describeGlobal();
    io:println("-----------------------MAIN METHOD: describeGlobal()---------------------------");
    //io:println(jsonResponse);

    //calling the connector action sObjectBasicInfo()
    jsonResponse, err = testSalesforce.sObjectBasicInfo(sampleSObject);
    io:println("------------------------MAIN METHOD: sObjectBasicInfo()------------------------");
    io:println(jsonResponse);

    //calling the connector action createSObjectRecord()
    json createAccountJsonpayload = {
                                        "Name":"Express Logistics and Transport",
                                        "Global_POD__c":"UK"
                                    };
    //jsonResponse, err = testSalesforce.createSObjectRecord(sampleSObject, createAccountJsonpayload);
    io:println("------------------------MAIN METHOD: createSObject()---------------------------");
    //io:println(jsonResponse);

    //calling the connector action upsertSObjectRowsByExternalId()
    //jsonResponse, err = testSalesforce.upsertSObjectRowsByExternalId();
    io:println("------------------------MAIN METHOD: upsertSObjectRowsByExternalId()-----------");
    //io:println(jsonResponse);

    //calling the connector action sObjectDescribe()
    jsonResponse, err = testSalesforce.sObjectDescribe(sampleSObject);
    io:println("------------------------MAIN METHOD: sObejctDescribe()-------------------------");
    io:println(jsonResponse);

    //calling the connector action sObjectRowsByExternalId()
    //jsonResponse, err = testSalesforce.upsertSObjectRowsByExternalId();
    io:println("------------------------MAIN METHOD: sObjectRowsByExternalId()-----------------");
    io:println(jsonResponse);

    ////calling to the connector action sObjectRecordsGetDeleted()
    //jsonResponse, err = testSalesforce.sObjectRecordsGetDeleted(sampleSObject, startDateAndTime, endDateAndTime);
    //io:println("------------------------MAIN METHOD: sObjectRecordsGetDeleted()----------------");
    //io:println(jsonResponse);
    //
    ////calling to the actionsObjectGetUpdated()
    //jsonResponse, err = testSalesforce.sObjectGetUpdated(sampleSObject, startDateAndTime, endDateAndTime);
    //io:println("------------------------MAIN METHOD: sObjectGetUpdated()-----------------------");
    //io:println(jsonResponse);

    //calling to the connector action sObjectNamedLayouts()
    //jsonResponse, err = testSalesforce.sObjectNamedLayouts(sampleSObject, namedLayoutInfo);
    io:println("--------------------------MAIN METHOD: sObjectNamedLayouts()---------------------");
    //io:println(jsonResponse);

    //calling to the connector action sObjectBlobRetrieve()
    string id = "";
    string blobField = "";
    blob blobResponse;
    //blobResponse, err = testSalesforce.sObjectBlobRetrieve(sampleSObject, id, blobField);
    io:println("--------------------------MAIN METHOD: sObjectBlobRetrieve()-----------------");
    //io:println(blobResponse);

    //callinto the connector action sObjectApprovalLayouts()
    //jsonResponse, err = testSalesforce.sObjectApprovalLayouts();
    io:println("---------------------------MAIN METHOD: sObjectApprovalLayouts()-------------");
    //io:println(jsonResponse);

    //callinto the connector action sObjectCompactLayouts()
    //jsonResponse, err = testSalesforce.sObjectCompactLayouts();
    io:println("---------------------------MAIN METHOD: sObjectCompactLayouts----------------");
    //io:println(jsonResponse);

    //callinto the connector action describeLayouts()
    //jsonResponse, err = testSalesforce.describeLayouts();
    io:println("---------------------------MAIN METHOD: describeLayouts()--------------------");
    //io:println(jsonResponse);

    //callinto the connector action sObjectQuickActions()
    //jsonResponse, err = testSalesforce.sObjectQuickActions();
    io:println("---------------------------MAIN METHOD: sObjectQuickActions()----------------");
    //io:println(jsonResponse);

    //callinto the connector action sObjectQuickActions()
    //jsonResponse, err = testSalesforce.sObjectQuickActions();
    io:println("---------------------------MAIN METHOD: sObjectQuickActions()----------------");
    //io:println(jsonResponse);

    //callinto the connector action sObjectRelationships();
    jsonResponse, err = testSalesforce.sObjectRelationships();
    io:println("---------------------------MAIN METHOD: sObjectRelationships()----------------");
    //io:println(jsonResponse);

    //callinto the connector action setPassword();
    jsonResponse, err = testSalesforce.setPassword();
    io:println("---------------------------MAIN METHOD: setPassword()-------------------------");
    //io:println(jsonResponse);

    //callinto the connector action deletePassword();
    jsonResponse, err = testSalesforce.deletePassword();
    io:println("---------------------------MAIN METHOD: deletePassword();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action platformEventSchemabyEventName();
    jsonResponse, err = testSalesforce.platformEventSchemabyEventName();
    io:println("---------------------------MAIN METHOD: platformEventSchemabyEventName();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action platformEventSchemabySchemaId();
    jsonResponse, err = testSalesforce.deletePassword();
    io:println("---------------------------MAIN METHOD: deletePassword();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action platformEventSchemabySchemaId();
    jsonResponse, err = testSalesforce.deletePassword();
    io:println("---------------------------MAIN METHOD: deletePassword();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action platformEventSchemabySchemaId();
    jsonResponse, err = testSalesforce.deletePassword();
    io:println("---------------------------MAIN METHOD: deletePassword();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action getInvocableActions();
    jsonResponse, err = testSalesforce.getInvocableActions();
    io:println("---------------------------MAIN METHOD: getInvocableActions();---------------------");
    //io:println(jsonResponse);

    jsonResponse, err = testSalesforce.doInvocableAction();
    io:println("---------------------------MAIN METHOD: doInvocableAction();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action listViewDescribe();
    jsonResponse, err = testSalesforce.listViewDescribe();
    io:println("---------------------------MAIN METHOD: listViewDescribe();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action parameterizedSearch();
    jsonResponse, err = testSalesforce.parameterizedSearch();
    io:println("---------------------------MAIN METHOD: parameterizedSearch();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action processApprovals();
    jsonResponse, err = testSalesforce.processApprovals();
    io:println("---------------------------MAIN METHOD: processApprovals();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action getProcessRules();
    jsonResponse, err = testSalesforce.getProcessRules();
    io:println("---------------------------MAIN METHOD: getProcessRules();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action query();
    jsonResponse, err = testSalesforce.query();
    io:println("---------------------------MAIN METHOD: query();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action queryAll();
    jsonResponse, err = testSalesforce.queryAll();
    io:println("---------------------------MAIN METHOD: queryAll();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action recentListView();
    jsonResponse, err = testSalesforce.recentListView();
    io:println("---------------------------MAIN METHOD: recentListView();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action recordCount();
    jsonResponse, err = testSalesforce.recordCount();
    io:println("---------------------------MAIN METHOD: recordCount();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action relevantItems();
    jsonResponse, err = testSalesforce.relevantItems();
    io:println("---------------------------MAIN METHOD: relevantItems();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action retrieveKnowledgeLanguageSettings();
    jsonResponse, err = testSalesforce.retrieveKnowledgeLanguageSettings();
    io:println("---------------------------MAIN METHOD: retrieveKnowledgeLanguageSettings();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action search();
    jsonResponse, err = testSalesforce.search();
    io:println("---------------------------MAIN METHOD: search();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action searchScopeAndOrder();
    jsonResponse, err = testSalesforce.searchScopeAndOrder();
    io:println("---------------------------MAIN METHOD: searchScopeAndOrder();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action searchResultLayouts();
    jsonResponse, err = testSalesforce.searchResultLayouts();
    io:println("---------------------------MAIN METHOD: searchResultLayouts();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action searchSuggestedRecords();
    jsonResponse, err = testSalesforce.searchSuggestedRecords();
    io:println("---------------------------MAIN METHOD: searchSuggestedRecords();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action searchSuggestedArticleTitleMatches();
    jsonResponse, err = testSalesforce.searchSuggestedArticleTitleMatches();
    io:println("---------------------------MAIN METHOD: searchSuggestedArticleTitleMatches();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action searchSuggestedQueries();
    jsonResponse, err = testSalesforce.searchSuggestedQueries();
    io:println("---------------------------MAIN METHOD: searchSuggestedQueries();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action getAllTabs();
    jsonResponse, err = testSalesforce.getAllTabs();
    io:println("---------------------------MAIN METHOD: getAllTabs();---------------------");
    //io:println(jsonResponse);

    //callinto the connector action getThemes();
    jsonResponse, err = testSalesforce.getThemes();
    io:println("---------------------------MAIN METHOD: getThemes();---------------------");
    //io:println(jsonResponse);
}
