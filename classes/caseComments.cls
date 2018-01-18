public class caseComments {
    public static id caseId{get;set;}
    public static List<Zendesk3Embed__Case_Comment__c> caseCommentsRecs{get;set;}
    public caseComments(ApexPages.StandardController controller){
         caseId = ApexPages.currentPage().getParameters().get('id');
        if(caseId==null){
            caseId = ((Zendesk3Embed__Case_Comment__c)controller.getRecord()).id;
        }
        if(caseId!=null){
            
            caseCommentsRecs = (List<Case_Comment__c>)Data.read('Select id,Zendesk3Embed__Comment_Id__c ,CreatedDate , CreatedBy.name , Zendesk3Embed__Comment__c  from Zendesk3Embed__Case_Comment__c  where Zendesk3Embed__Case__c =:caseId order by CreatedDate desc', 
                                              new Map<String, Object> {
                                                  'caseId'	=> caseId});
        }
    }
    @AuraEnabled
    public static List<Case_Comment__c> forRefresh(String caseId){
        caseCommentsRecs = (List<Case_Comment__c>)Data.read('Select id,Zendesk3Embed__Comment_Id__c ,CreatedDate , CreatedBy.name , Zendesk3Embed__Comment__c  from Zendesk3Embed__Case_Comment__c  where Zendesk3Embed__Case__c =:caseId order by CreatedDate desc', 
                                              new Map<String, Object> {
                                                  'caseId'	=> caseId});
        return caseCommentsRecs;
    }
    
    public void forRefresh(){
        caseCommentsRecs = (List<Case_Comment__c>)Data.read('Select id,Zendesk3Embed__Comment_Id__c ,CreatedDate , CreatedBy.name , Zendesk3Embed__Comment__c  from Zendesk3Embed__Case_Comment__c  where Zendesk3Embed__Case__c =:caseId order by CreatedDate desc', 
                                              new Map<String, Object> {
                                                  'caseId'	=> caseId});
    }
    
    @AuraEnabled
    public static String sessionId() {
        return UserInfo.getSessionId();
    }
}