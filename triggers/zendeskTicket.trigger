trigger zendeskTicket on Case (after insert,after update,after delete) {
    if(Trigger.isInsert){
        for(Case zen: Trigger.New){
            if(zen.Ticket_Id__c==null && zen.Zendesk_Record__c == true){
              zendeskController.createTicket(zen.Id,zen.Subject, zendeskUtility.preventNull(zen.Description),zen.Status,zen.Priority,zen.Origin,zen.Group__c,zen.ContactId);
              zendeskController.postComment(zen.Description,zen.Id);
            }
        }
    }
    
    if(Trigger.isUpdate){        
        for(Case zen: Trigger.New){
            Case before = System.Trigger.oldMap.get(zen.Id);
            if(zen.Ticket_Id__c != null && zen.Zendesk_Record__c == true){
                    String comment;
                    if(zen.Description != before.Description){
                        comment=zen.Description;
                        zendeskController.postComment(comment,zen.Id);
                    }
                    String jsonBody = zendeskUtility.ticketJson(zen.Ticket_Id__c,zen.Subject,comment,zen.Status,zen.Priority,zen.Origin,zen.Group__c,zen.ContactId);                   
                    zendeskController.updateTicket(zen.Id,jsonBody);
            }     
        }
    }
    
    if(Trigger.isDelete){
        for(Case zen: Trigger.Old){
            if(zen.Ticket_Id__c!=null){
                zendeskController.deleteTicket(zen.Ticket_Id__c);
            }
        }
    }
}