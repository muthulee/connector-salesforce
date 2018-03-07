package src.wso2.salesforce;

import ballerina.net.uri;
import org.wso2.ballerina.connectors.oauth2;
import ballerina.net.http;
import ballerina.io;

@Description {value:"Salesforcerest client connector"}
@Param {value:"baseUrl: The endpoint base url"}
@Param {value:"accessToken: The access token of the account"}
@Param {value:"clientId: The client Id of the account"}
@Param {value:"clientSecret: The client secret of the account"}
@Param {value:"refreshToken: The refresh token of the account"}
@Param {value:"refreshTokenEndpoint: The refresh token endpoint url"}
@Param {value:"refreshTokenPath: The path for obtaining a refresh token"}
@Param {value:"apiVersion: API version available"}

public connector ClientConnector (string baseUrl, string accessToken, string clientId, string clientSecret, string refreshToken,
                                  string refreshTokenEndpoint, string refreshTokenPath, string apiVersion) {

    endpoint<oauth2:ClientConnector> oauth2Connector {
        create oauth2:ClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken,
                                      refreshTokenEndpoint, refreshTokenPath);
    }
    http:HttpConnectorError e;
    error err = {};

    @Description {value:"List summary details about each REST API version available"}
    @Return {value:"Array of available API versions"}
    @Return {value:"Error occured"}

    action listAvailableApiVersions () (ApiVersion[], error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        ApiVersion[] apiVersions = [];
        json[] apiVersionsJsonArray = [];
        int i = 0;

        response, e = oauth2Connector.get(BASE_URI, request);
        io:println("Error is:");
        io:println(e);
        json jsonResponse = response.getJsonPayload();
        //io:println("JSON Payload is: " + jsonResponse.toString());
        apiVersionsJsonArray, err = (json[])jsonResponse;
        //io:println("Json casted response is:");
        //io:println(apiVersionsJsonArray);

        foreach element in apiVersionsJsonArray {
            //io:println(element);
            apiVersions[i], err = <ApiVersion>element;
            //io:println(apiVersions[i]);
            i = i + 1;
        }

        return apiVersions, err;
    }

    @Description {value:"Lists the resources available for the specified API version"}
    @Param {value:"requestingApiVersion: The api version to get resources"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action listResourcesByApiVersion (string requestingApiVersion) (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + requestingApiVersion;
        response, e = oauth2Connector.get(requestURI, request);
        //io:println(response.getJsonPayload());
        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Lists limits information for your organization"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action listOrganizationLimits () (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + LIMITS_SUFFIX;
        response, e = oauth2Connector.get(requestURI, request);

        json jsonResponse = response.getJsonPayload();

        return jsonResponse, err;
    }

    @Description {value:"Lists the available objects and their metadata for your organization and available to the logged-in user"}
    @Param {value:"apiVersion: the api version to send request"}
    @Return {value:"Array of available objects"}
    @Return {value:"Error occured"}
    action describeGlobal () (json, error) {
        http:OutRequest request = {};
        http:InResponse response = {};
        SObject[] sobjects = [];
        int i = 0;

        string requestURI = BASE_URI + apiVersion + DESCRIBE_GLOBAL_SUFIX;

        response, e = oauth2Connector.get(requestURI, request);
        json jsonResponse = response.getJsonPayload();
        //io:println("Json response is: \n" + jsonResponse.sobjects.toString());
        //sobjectsJsonArray, err = jsonResponse.sobjects;
        //io:println(sobjectsJsonArray);
        //io:println(err);
        //
        //foreach element in jsonResponse.sobjects {
        //    //io:println(element);
        //    sobjects[i], err = <SObject>element;
        //    //io:println(sobjects[i]);
        //    i = i + 1;
        //}
        return jsonResponse, err;
    }

    //equals to create new record
    @Description {value:"Creates new records"}
    @Param {value:"apiVersion: The api version to send request to"}
    @Param {value:"sobjectName: The relevant sobject name"}
    @Param {value:"payload: json payload containing record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createSObject (string sobjectName, json payload) (string, error) {
        http:OutRequest request = {};
        http:InResponse response = {};

        string requestURI = BASE_URI + apiVersion + DESCRIBE_GLOBAL_SUFIX + sobjectName;
        request.setJsonPayload(payload);
        response, err = oauth2Connector.post(requestURI, request);
        json jsonResponse = response.getJsonPayload();
        json id = jsonResponse.id;

        return id.toString(), err;
    }

    //@Description {value:"Create an Account type object"}
    //@Param {value:"apiVersion: the api version to send request"}
    //@Return {value:"ID of created account"}
    //@Return {value:"Error occured"}
    //action createAccount (Account account) (string, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //
    //    //string requestURI = VERSIONS_URI + apiVersion + CREATE_ACCOUNT_SUFFIX;
    //    string requestURI = VERSIONS_URI + apiVersion + CREATE_ACCOUNT_SUFFIX + "/" + "001L000000vmdARIAY";
    //
    //    var jsonAccount, _ = <json>account;
    //    io:println("account object converted to jason:");
    //    io:println(jsonAccount);
    //
    //    //setting "Global_POD__c" customized field for wso2 salesforce
    //    jsonAccount["Global_POD__c"] = "UK";
    //    io:println(jsonAccount);
    //
    //    request.setJsonPayload(jsonAccount);
    //    response, e = oauth2Connector.get(requestURI, request);
    //    //response, e = oauth2Connector.get(requestURI, request);
    //    io:println("get response for Account");
    //    json jsonResponse = response.getJsonPayload();
    //    io:println("-----------------CREATE ACCOUNT-----------------------");
    //    io:println(jsonResponse);
    //    int length = lengthof (jsonResponse.recentItems);
    //    io:println(length);
    //    io:println(jsonResponse.recentItems[0].Id);
    //
    //    var accountId, _ = (string)jsonResponse.recentItems[0].Id;
    //
    //    return accountId, err;
    //}
    //
    //@Description {value:"Update account for the required ID"}
    //@Param {value:"apiVersion: the api version to send request"}
    //@Return {value:"SUCCESS or FAILED message"}
    //@Return {value:"Error occured"}
    //action updateAccount (string id, Account account) (boolean, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    boolean success;
    //
    //    string requestURI = VERSIONS_URI + apiVersion + CREATE_ACCOUNT_SUFFIX + "/" + id;
    //
    //    var jsonAccount, _ = <json>account;
    //    request.setJsonPayload(jsonAccount);
    //
    //    response, e = oauth2Connector.patch(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //    io:println(jsonResponse);
    //    if (jsonResponse != null) {
    //        success = true;
    //    } else {
    //        success = false;
    //    }
    //
    //    response, e = oauth2Connector.get(requestURI, request);
    //    io:println(response.getJsonPayload());
    //
    //    return success, err;
    //}
    //
    //@Description {value:"Delete account for the required ID"}
    //@Param {value:"apiVersion: the api version to send request"}
    //@Return {value:"SUCCESS or FAILED message"}
    //@Return {value:"Error occured"}
    //action deleteAccount (string id) (string, error) {
    //    http:OutRequest request = {};
    //    http:InResponse response = {};
    //    string message = "";
    //
    //    string requestURI = VERSIONS_URI + apiVersion + CREATE_ACCOUNT_SUFFIX + "/" + id;
    //
    //    response, e = oauth2Connector.delete(requestURI, request);
    //    json jsonResponse = response.getJsonPayload();
    //
    //    if (jsonResponse != null) {
    //        message = "SUCCESS!";
    //    } else {
    //        message = "FAILED!";
    //    }
    //
    //    return message, err;
    //}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// TODO Move these structs to another package once https://github.com/ballerina-lang/ballerina/issues/4736 is fixed.//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

public struct ApiVersion {
    string |version|;
    string label;
    string url;
}

public struct SObject {
    boolean activateable;
    boolean custom;
    boolean customSetting;
    boolean createable;
    boolean deletable;
    boolean deprecatedAndHidden;
    boolean feedEnabled;
    string keyPrefix;
    string label;
    string labelPlural;
    boolean layoutable;
    boolean mergeable;
    boolean mruEnabled;
    string name;
    boolean queryable;
    boolean replicateable;
    boolean retrieveable;
    boolean searchable;
    boolean triggerable;
    boolean undeletable;
    boolean updateable;
    json urls;
}

public struct ConnectorError {
    string statusCode;
    string message;
    boolean isConnectionError;
    SalesforceError salesforceError;
}

public struct SalesforceError {
    string errorCode;
    string message;
}

public struct Account {
    string AccountNumber;
    string[] AccountSource;
    float AnnualRevenue;
    string BillingAddress;
    string BillingCity;
    string BillingCountry;
    string[] BillingCountryCode;
    string[] BillingGeocodeAccuracy;
    float BillingLatitude;
    float BillingLongitude;
    string BillingPostalCode;
    string BillingState;
    string[] BillingStateCode;
    string BillingStreet;
    string[] CleanStatus;
    ConnectionReceivedPointer ConnectionReceivedId;
    ConnectionSentPointer ConnectionSentId;
    string Description;
    string DunsNumber;
    string Fax;
    string[] Industry;
    boolean IsCustomerPortal;
    boolean IsDeleted;
    boolean IsPartner;
    boolean IsPersonAccount;
    string Jigsaw;
    string LastActivityDate;
    string LastReferencedDate;
    string LastViewedDate;
    MasterRecordPointer MasterRecordId;
    string NaicsCode;
    string NaicsDesc;
    string Name;
    int NumberOfEmployees;
    OperatingHoursPointer OperatingHoursId;
    OwnerPointer OwnerId;
    string[] Ownership;
    ParentPointer ParentId;
    string Phone;
    string PhotoUrl;
    string[] Rating;
    RecordTypePointer RecordTypeId;
    string[] Salutation;
    string ShippingAddress;
    string ShippingCity;
    string ShippingCountry;
    string[] ShippingCountryCode;
    float[] ShippingGeocodeAccuracy;
    float ShippingLatitude;
    float ShippingLongitude;
    string ShippingPostalCode;
    string ShippingState;
    string[] ShippingStateCode;
    string ShippingStreet;
    string Sic;
    string SicDesc;
    string Site;
    string TickerSymbol;
    string Tradestyle;
    string[] Type;
    string Website;
    string YearStarted;
}

public struct ConnectionReceivedPointer {
    string id;
}

public struct ConnectionSentPointer {
    string id;
}

public struct MasterRecordPointer {
    string id;
}

public struct OperatingHoursPointer {
    string id;
}

public struct OwnerPointer {
    string id;
}

public struct AccountPointer {
    string id;
}
public struct RecordTypePointer {
    string id;
}

public struct ParentPointer {
    string id;
}

public struct Lead {
    string Address;
    float AnnualRevenue;
    string City;
    string[] CleanStatus;
    string Company;
    string CompanyDunsNumber;
    ConnectionReceivedPointer ConnectionReceivedId;
    ConnectionSentPointer ConnectionSentId;
    ConvertedAccountPointer ConvertedAccountId;
    ConvertedContactPointer ConvertedContactId;
    string ConvertedDate;
    ConvertedOpportunityReference ConvertedOpportunityId;
    string Country;
    string[] CountryCode;
    string[] CurrencyIsoCode;
    string Description;
    string[] Division;
    string Email;
    string EmailBouncedDate;
    string EmailBouncedReason;
    string Fax;
    string FirstName;
    boolean HasOptedOutOfEmail;
    float[] GeocodeAccuracy;
    IndividualPointer IndividualId;
    string[] Industry;
    boolean IsConverted;
    boolean IsDeleted;
    boolean IsUnreadByOwner;
    string Jigsaw;
    string LastActivityDate;
    string LastName;
    string LastReferencedDate;
    string LastViewedDate;
    float Latitude;
    float Longitude;
    string[] LeadSource;
    MasterRecordPointer MasterRecordId;
    string MiddleName;
    string MobilePhone;
    string Name;
    int NumberOfEmployees;
    OwnerPointer OwnerId;
    PartnerAccountPointer PartnerAccountId;
    string Phone;
    string PhotoUrl;
    string PostalCode;
    string Rating;
    RecordTypeointer RecordTypeId;
    string[] Salutation;
    ScoreIntelligenceointer ScoreIntelligenceId;
    string State;
    string[] StateCode;
    string[] Status;
    string Street;
    string Suffix;
    string Title;
    string Website;
}

public struct ConvertedAccountPointer {
    string id;
}

public struct ConvertedContactPointer {
    string id;
}
public struct ConvertedOpportunityointer {
    string id;
}
public struct IndividualPointer {
    string id;
}
public struct PartnerAccountPointer {
    string id;
}
public struct RecordTypeointer {
    string id;
}

public struct ScoreIntelligencePointer {
    string id;
}

public struct ConvertedOpportunityReference {
    string id;
}

public struct ScoreIntelligenceointer {
    string id;
}