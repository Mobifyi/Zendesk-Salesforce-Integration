trigger TicketComment on Case_Comment__c (after insert) {
    if(Trigger.isInsert){
      Set<Id> commentId = new Set<ID>();
        for(Case_Comment__c c :Trigger.new){
            commentId.add(c.id);
        }
        List<Case_Comment__c>insertCaseComm = Data.read('select id,Zendesk_Record__c,Comment__c,Zendesk3Embed__Case__c from Case_Comment__c where id in :commentId ', new Map<String, Object> {'commentId' => commentId});
        System.debug('insertCaseComm=='+insertCaseComm);
        if(insertCaseComm[0].Zendesk_Record__c == true ){
            String csId = insertCaseComm[0].Zendesk3Embed__Case__c;
            System.debug('csId=='+csId);
            List<Case> caseData = Data.read('select id,Zendesk3Embed__Ticket_Id__c,Subject,Duplicate_Comment__c,Zendesk_Record__c,Status,Priority,Origin,Group__c,ContactId from Case where id =: csId',new Map<String,Object>{'csId' => csId});
            if(caseData[0].Zendesk3Embed__Ticket_Id__c != null){
                String jsonBody = zendeskUtility.ticketJson(caseData[0].Zendesk3Embed__Ticket_Id__c,caseData[0].Subject,insertCaseComm[0].Comment__c,caseData[0].Status,caseData[0].Priority,caseData[0].Origin,caseData[0].Group__c,caseData[0].ContactId);                   
                zendeskController.updateTicket(insertCaseComm[0].Case__c,jsonBody);
                System.debug('jsonBody'+jsonBody);     //ca.Case__c,jsonBody      
            }
        }
    }
}