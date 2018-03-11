package src.wso2.salesforce_primary;

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

public struct QueryResult {
    boolean done;
    int totalSize;
    json[] records;
    string nextRecordsUrl;
}

public struct QueryPlan {
    int cardinality;
    string[] fields;
    string leadingOperationType;
    FeedbackNote[] notes;
    float relativeCost;
    int sobjectCardinality;
    string sobjectType;
}

public struct FeedbackNote {
    string description;
    string[] fields;
    string tableEnumOrId;
}