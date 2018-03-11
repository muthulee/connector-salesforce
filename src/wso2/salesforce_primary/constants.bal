package src.wso2.salesforce_primary;

//Salesforce endpoints
public const string BASE_URI = "/services/data";
public const string SOBJECTS = "sobjects";
public const string CREATE_ACCOUNT_SUFFIX = "/sobjects/Account";
public const string LIMITS_SUFFIX = "limits";
public const string DESCRIBE = "describe";
public const string QUERY = "query";
public const string APPROVAL_LAYOUT_SUFFIX = "/describe/approvalLayouts/";
public const string COMPACT_LAYOUT_SUFFIX = "/describe/compactLayouts";
public const string DESCRIBE_LAYOUT_SUFFIX = "/describe/layouts/";
public const string PLATFORM_ACTION_SUFFIX = "/sobjects/PlatformAction";
public const string QUICK_ACTIONS_SUFFIX = "/quickActions/";
public const string EVENT_SCHEMA_ID_SUFFIX = "/event/eventSchema/";
public const string ACTIONS_SUFFIX = "/actions";
public const string PROCESS_APPROVALS_SUFFIX = "/process/approvals/";
public const string RECENT_LISTVIEW_SUFFIX = "/listviews/recent";
public const string RECENTLY_VIEWD_ITEMS_SUFFIX = "/recent";
public const string RECORD_COUNT_SUFFIX = "/limits/recordCount?sObjects=";
public const string RELEVANT_ITEMS_SUFFIX = "/relevantItems";
public const string RETRIEVE_KNOWLEDGE_LANGUAGE_SUFFIX = "/knowledgeManagement/settings";
public const string SEARCH_SUFFIX = "/search/?q=";
public const string SEARCH_SCOPE_ORDER_SUFFIX = "/search/scopeOrder";
public const string SEARCH_RESULT_LAYOUT_SUFFIX = "/search/layout/?q";
public const string SEARCH_SUGGESTED_RECORD_SUFFIX = "/search/suggestions?q=";
public const string SEARCH_SUGGEST_TITLE_SUFFIX = "/search/suggestTitleMatches?q=";
public const string SEARCH_SUGGESTED_QUERIES = "/search/suggestSearchQueries?q=";
public const string TABS_SUFFIX = "/tabs/";
public const string THEMES_SUFFIX = "/theme";

public const string NAMED_LAYOUTS_SUFFIX = "/describe/namedLayouts/";

//=================================  SObjects  ==========================================//
public const string ACCOUNT = "Account";
public const string LEAD = "Lead";
public const string CONTACT = "Contact";
public const string OPPORTUNITY = "Opportunity";
public const string PRODUCT = "Product";