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

public function main (string[] args) {

    //calling the ClientConnector and creating the instance
    endpoint<salesforce:ClientConnector> testSalesforce {
        create salesforce:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath, apiVersion);
    }
    http:HttpConnectorError e = {};
    error err = {};
    json jsonResponse;

    /////////////////////////////////////////////////////////////////////////////////////////////
    //                                  calling the connector actions
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
    jsonResponse, err = testSalesforce.sObjectBasicInfo("Account");
    io:println("------------------------MAIN METHOD: sObjectBasicInfo()------------------------");
    io:println(jsonResponse);

    //calling the connector action createSObjectRecord()
    json createAccountJsonpayload = {
                                         "Name":"Express Logistics and Transport",
                                         "Global_POD__c":"UK"
                                     };
    //jsonResponse, err = testSalesforce.createSObjectRecord("Account", createAccountJsonpayload);
    io:println("------------------------MAIN METHOD: createSObject()---------------------------");
    //io:println(jsonResponse);

    //calling the connector action upsertSObjectRowsByExternalId()
    //jsonResponse, err = testSalesforce.upsertSObjectRowsByExternalId();
    io:println("------------------------MAIN METHOD: upsertSObjectRowsByExternalId()-----------");
    //io:println(jsonResponse);

    //calling the connector action sObjectDescribe()
    jsonResponse, err = testSalesforce.sObjectDescribe("Account");
    io:println("------------------------MAIN METHOD: sObejctDescribe()-------------------------");
    //io:println(jsonResponse);



    //calling the connector action createAccount()
    //salesforce:Account account = {};
    //account.Name = "Express Logistics and Transport";
    //string id = "";
    //
    ////id, err = testSalesforce.createAccount(account);
    //io:println("-----------------------MAIN METHOD: createAccount()----------------------------");
    //if (err != null) {
    //    io:println(id);
    //} else {
    //    io:println(err);
    //}
    //
    //account.IsPartner = true;
    //account.BillingCountry = "USA";
    //boolean success;
    ////success, err = testSalesforce.updateAccount("001L000000vmdARIAY", account);
    //io:println("------------------------MAIN METHOD: updateAccount()---------------------------");
    //if (success) {
    //    io:println("SUCCESS!");
    //} else {
    //    io:println(err);
    //}


}
