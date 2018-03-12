package src.wso2.salesforce_secondary;

import src.wso2.salesforce_primary as sfp;

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

    endpoint<sfp:CoreClientConnector> coreClientConnector {
        create sfp:CoreClientConnector(baseUrl, accessToken, clientId, clientSecret, refreshToken, refreshTokenEndpoint, refreshTokenPath, apiVersion);
    }

    error _;

    // ============================ ACCOUNT SObject: get, create, update, delete ===================== //

    @Description {value:"Accesses Account SObject records based on the Account object ID"}
    @Param {value:"accountId: The relevant account's id"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action getAccountById (string accountId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.getRecord(sfp:ACCOUNT, accountId);

        return response, sfConnectorError;
    }

    @Description {value:"Creates new Account object record"}
    @Param {value:"accountRecord: json payload containing Account record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createAccount (json accountRecord) (string, sfp:SalesforceConnectorError) {
        sfp:SalesforceConnectorError sfConnectorError;
        string accountId;

        accountId, sfConnectorError = coreClientConnector.createRecord(sfp:ACCOUNT, accountRecord);

        return accountId, sfConnectorError;
    }

    @Description {value:"Updates existing Account object record"}
    @Param {value:"accountId: Specified account id"}
    @Param {value:"accountRecord: json payload containing Account record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action updateAccount (string accountId, json accountRecord) (boolean, sfp:SalesforceConnectorError) {
        boolean isUpdated;
        sfp:SalesforceConnectorError sfConnectorError;

        isUpdated, sfConnectorError = coreClientConnector.updateRecord(sfp:ACCOUNT, accountId, accountRecord);

        return isUpdated, sfConnectorError;
    }

    @Description {value:"Deletes existing Account's records"}
    @Param {value:"accountId: The id of the relevant Account record supposed to be deleted"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action deleteAccount (string accountId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.deleteRecord(sfp:ACCOUNT, accountId);

        return response, sfConnectorError;
    }

    // ============================ LEAD SObject: get, create, update, delete ===================== //

    @Description {value:"Accesses Lead SObject records based on the Lead object ID"}
    @Param {value:"leadId: The relevant lead's id"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action getLeadById (string leadId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.getRecord(sfp:LEAD, leadId);

        return response, sfConnectorError;
    }

    @Description {value:"Creates new Lead object record"}
    @Param {value:"leadRecord: json payload containing Lead record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createLead (json leadRecord) (json, sfp:SalesforceConnectorError) {
        sfp:SalesforceConnectorError sfConnectorError;
        string leadId;

        leadId, sfConnectorError = coreClientConnector.createRecord(sfp:LEAD, leadRecord);

        return leadId, sfConnectorError;
    }

    @Description {value:"Updates existing Lead object record"}
    @Param {value:"leadId: Specified lead id"}
    @Param {value:"leadRecord: json payload containing Lead record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action updateLead (string leadId, json leadRecord) (json, sfp:SalesforceConnectorError) {
        boolean isUpdated;
        sfp:SalesforceConnectorError sfConnectorError;

        isUpdated, sfConnectorError = coreClientConnector.updateRecord(sfp:LEAD, leadId, leadRecord);

        return isUpdated, sfConnectorError;
    }

    @Description {value:"Deletes existing Lead's records"}
    @Param {value:"leadId: The id of the relevant Lead record supposed to be deleted"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action deleteLead (string leadId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.deleteRecord(sfp:LEAD, leadId);

        return response, sfConnectorError;
    }

    // ============================ CONTACTS SObject: get, create, update, delete ===================== //

    @Description {value:"Accesses Contacts SObject records based on the Contact object ID"}
    @Param {value:"contactId: The relevant contact's id"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action getContactById (string contactId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.getRecord(sfp:CONTACT, contactId);

        return response, sfConnectorError;
    }

    @Description {value:"Creates new Contact object record"}
    @Param {value:"contactRecord: json payload containing Contact record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createContact (json contactRecord) (json, sfp:SalesforceConnectorError) {
        sfp:SalesforceConnectorError sfConnectorError;
        string contactId;

        contactId, sfConnectorError = coreClientConnector.createRecord(sfp:CONTACT, contactRecord);

        return contactId, sfConnectorError;
    }

    @Description {value:"Updates existing Contact object record"}
    @Param {value:"contactId: Specified contact id"}
    @Param {value:"contactRecord: json payload containing contact record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action updateContact (string contactId, json contactRecord) (json, sfp:SalesforceConnectorError) {
        boolean isUpdated;
        sfp:SalesforceConnectorError sfConnectorError;

        isUpdated, sfConnectorError = coreClientConnector.updateRecord(sfp:CONTACT, contactId, contactRecord);

        return isUpdated, sfConnectorError;
    }

    @Description {value:"Deletes existing Contact's records"}
    @Param {value:"contactId: The id of the relevant Contact record supposed to be deleted"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action deleteContact (string contactId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.deleteRecord(sfp:CONTACT, contactId);

        return response, sfConnectorError;
    }

    // ============================ OPPORTUNITIES SObject: get, create, update, delete ===================== //

    @Description {value:"Accesses Opportunities SObject records based on the Opportunity object ID"}
    @Param {value:"opportunityId: The relevant opportunity's id"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action getOpportunityById (string opportunityId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.getRecord(sfp:OPPORTUNITY, opportunityId);

        return response, sfConnectorError;
    }

    @Description {value:"Creates new Opportunity object record"}
    @Param {value:"opportunityRecord: json payload containing Opportunity record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createOpportunity (json opportunityRecord) (json, sfp:SalesforceConnectorError) {
        sfp:SalesforceConnectorError sfConnectorError;
        string opportunityId;

        opportunityId, sfConnectorError = coreClientConnector.createRecord(sfp:OPPORTUNITY, opportunityRecord);

        return opportunityId, sfConnectorError;
    }

    @Description {value:"Updates existing Opportunity object record"}
    @Param {value:"opportunityId: Specified opportunity id"}
    @Param {value:"opportunityRecord: json payload containing Opportunity record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action updateOpportunity (string opportunityId, json opportunityRecord) (json, sfp:SalesforceConnectorError) {
        boolean isUpdated;
        sfp:SalesforceConnectorError sfConnectorError;

        isUpdated, sfConnectorError = coreClientConnector.updateRecord(sfp:OPPORTUNITY, opportunityId, opportunityRecord);

        return isUpdated, sfConnectorError;
    }

    @Description {value:"Deletes existing Opportunity records"}
    @Param {value:"opportunityId: The id of the relevant Opportunity record supposed to be deleted"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action deleteOpportunity (string opportunityId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.deleteRecord(sfp:OPPORTUNITY, opportunityId);

        return response, sfConnectorError;
    }

    // ============================ PRODUCTS SObject: get, create, update, delete ===================== //

    @Description {value:"Accesses Products SObject records based on the Product object ID"}
    @Param {value:"productId: The relevant product's id"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action getProductById (string productId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.getRecord(sfp:PRODUCT, productId);

        return response, sfConnectorError;
    }

    @Description {value:"Creates new Product object record"}
    @Param {value:"productRecord: json payload containing Product record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action createProduct (json productRecord) (json, sfp:SalesforceConnectorError) {
        sfp:SalesforceConnectorError sfConnectorError;
        string productId;

        productId, sfConnectorError = coreClientConnector.createRecord(sfp:PRODUCT, productRecord);

        return productId, sfConnectorError;
    }

    @Description {value:"Updates existing Product object record"}
    @Param {value:"productId: Specified product id"}
    @Param {value:"productRecord: json payload containing product record data"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action updateProduct (string productId, json productRecord) (json, sfp:SalesforceConnectorError) {
        boolean isUpdated;
        sfp:SalesforceConnectorError sfConnectorError;

        isUpdated, sfConnectorError = coreClientConnector.updateRecord(sfp:PRODUCT, productId, productRecord);

        return isUpdated, sfConnectorError;
    }

    @Description {value:"Deletes existing product's records"}
    @Param {value:"productId: The id of the relevant Product record supposed to be deleted"}
    @Return {value:"response message"}
    @Return {value:"Error occured during oauth2 client invocation."}
    action deleteProduct (string productId) (json, sfp:SalesforceConnectorError) {
        json response;
        sfp:SalesforceConnectorError sfConnectorError;

        response, sfConnectorError = coreClientConnector.deleteRecord(sfp:PRODUCT, productId);

        return response, sfConnectorError;
    }
}