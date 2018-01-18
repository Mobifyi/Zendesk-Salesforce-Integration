public class Cases {
    public static List<Case> allCases {get; set;}
    static{
        allCases = [Select id, Zendesk3Embed__zen_Ticket_Id__c, Zendesk3Embed__Group__r.Name,Zendesk3Embed__Requester__r.Name, CreatedDate , LastModifiedDate, CaseNumber , Subject, Status  from Case order by LastModifiedDate DESC limit 50000];
    }
    
    @AuraEnabled
    public static String sessionId() {
        return UserInfo.getSessionId();
    }
    
    @AuraEnabled
    public static List<Case> init() {
        return allCases;
    }
}