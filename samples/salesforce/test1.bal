//package samples.salesforce;


import ballerina. io;
import ballerina.net.http;
import src.salesforce;

string url = "https://wso2--wsbox.cs8.my.salesforce.com";
string accessToken = "00DL0000002ASPS!ASAAQHeqWoNZcLhSij5irvaZBXR9m0SFxcmZ90jKFMLVt0D8SgQLouhEZpvCTmDbcDgOajRCSR.Gl56uQQrDBE_H7JWQkWNH";
string clientId = "3MVG9MHOv_bskkhSA6dmoQao1M5bAQdCQ1ePbHYQKaoldqFSas7uechL0yHewu1QvISJZi2deUh5FvwMseYoF";
string clientSecret = "1164810542004702763";
string refreshToken = "5Aep86161DM2BuiV6zOy.J2C.tQMhSDLfkeFVGqMEInbvqLfxylW8qZmyAc0zMaw2zTPkk6W1GMsXikrYOdIdfS";
string refreshTokenEndpoint = "https://test.salesforce.com";
string refreshTokenPath = "/services/oauth2/token";

public function main (string[] args) {
error Error = {};

    salesforce:SalesforceConnector salesforceConnector = {};
    salesforceConnector.init(url, accessToken, refreshToken, clientId, clientSecret, refreshTokenEndpoint, refreshTokenPath);

    ///////////////////////////////////////////////////////////////////////////////////////////////////////////

    io:println("------------------------MAIN METHOD: API Versions----------------------");
    try{
        json jresponse = salesforceConnector.getAvailableApiVersions();
        io:println(jresponse);
    } catch(error e){
        io:println(e);
    }

    io:println("\n\n------------------------MAIN METHOD: API Versions----------------------");
    try{
        json jresponse = salesforceConnector.getResourcesByApiVersion("v37.0");
        io:println(jresponse);
    } catch(error e){
        io:println(e);
    }
}
