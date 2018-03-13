package src.wso2.salesforce_primary;

import ballerina.net.http;
// ============================ function to check and set errors ===================== //

@Description {value:"Function to check errors and set errors to relevant error types"}
@Param {value:"response: http response"}
@Param {value:"httpError: http connector error"}
@Return {value:"Error occured"}
function checkAndSetErrors (http:InResponse response, http:HttpConnectorError httpError) (SalesforceConnectorError) {
    SalesforceConnectorError connectorError;
    if (httpError != null) {
        connectorError = {messages:[httpError.message], connectionError:httpError};
    } else if (response.statusCode != 200 && response.statusCode != 201 && response.statusCode != 204) {
        json[] body;
        error _;
        body, _ = (json[])response.getJsonPayload();
        connectorError = {messages:[], salesforceErrors:[]};
        foreach i, e in body {
            SalesforceError sfError = {message:e.message.toString(), errorCode:e.errorCode.toString()};
            connectorError.messages[i] = e.message.toString();
            connectorError.salesforceErrors[i] = sfError;
        }
    }
    return connectorError;
}