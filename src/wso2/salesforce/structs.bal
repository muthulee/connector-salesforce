package src.wso2.salesforce;

import ballerina.net.http;

// TODO Move these structs to another package once https://github.com/ballerina-lang/ballerina/issues/4736 is fixed.//
public struct ApiVersion {
    string |version|;
    string label;
    string url;
}


public struct SalesforceError {
    //string[] fields;
    string message;
    string errorCode;
}

public struct SalesforceConnectorError {
    string[] messages;
    http:HttpConnectorError connectionError;
    SalesforceError[] salesforceErrors;
}