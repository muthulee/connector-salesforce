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
string accessToken = "00DL0000002ASPS!ASAAQMnyywYsiu7OSV2qwjOKwYIPizFk382vfthL09dI9NQbLcIQva5D8yN0_dbz4Ob1andU9a31bGXJxqyAzum2vI90AFjh";
string clientId = "3MVG9MHOv_bskkhSA6dmoQao1M5bAQdCQ1ePbHYQKaoldqFSas7uechL0yHewu1QvISJZi2deUh5FvwMseYoF";
string clientSecret = "1164810542004702763";
string refreshToken = "5Aep86161DM2BuiV6zOy.J2C.tQMhSDLfkeFVGqm5VhIyWadTxgjEN3VGRL0crtsZWsQjrkYVUEpvgLwxF0PAEr";
string refreshTokenEndpoint = "https://test.salesforce.com";
string refreshTokenPath = "/services/oauth2/token";
string apiVersion = "v37.0";

public function main (string[] args) {

    //calling the ClientConnector and creating the instance
    endpoint<salesforce:ClientConnector> testSalesforce {
        create salesforce:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath);
    }

    //calling the connector method listAvailableApiVersions()
    salesforce:ApiVersion[] apiVersions = [];
    apiVersions, err = testSalesforce.listAvailableApiVersions();
    io:println("------------------------MAIN METHOD: listAvailableApiVersions()----------------------");
    io:println(apiVersions);
    io:println(err);

    //calling the connector method describeGlobal
    salesforce:SObject[] sobjects = [];
    //io:println(apiVersions[0].|version|);
    sobjects, err = testSalesforce.describeGlobal(apiVersion);
    io:println("-----------------------MAIN METHOD: describeGlobal()---------------------------");
    io:println(sobjects[0]);
    io:println(err);
}
