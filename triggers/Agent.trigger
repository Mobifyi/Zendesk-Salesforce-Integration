trigger Agent on Contact (after insert,after update,after delete) {
    if(Trigger.isInsert){
        for(Contact con:Trigger.New){
            if(con.Zendesk_Record__c == true){
                String fullName=zendeskUtility.preventNull(con.Salutation)+' '+zendeskUtility.preventNull(con.FirstName)+' '+zendeskUtility.preventNull(con.LastName);
                zendeskController.createUser(con.Id,fullName,con.Email_Id__c,'end-user');    
            }
        }   
    }
    
    if(trigger.isUpdate){
        for(Contact con:Trigger.New){
            Contact before = System.Trigger.oldMap.get(con.Id);
            if(con.Agent_Id__c!=null){
                if(before.FirstName!=con.FirstName || before.Salutation!=con.Salutation || before.LastName!=con.LastName){
                    String fullName=zendeskUtility.preventNull(con.Salutation)+' '+zendeskUtility.preventNull(con.FirstName)+' '+zendeskUtility.preventNull(con.LastName);
                	zendeskController.updateAgent(con.Agent_Id__c,fullName,'end-user');  
                }
            }
        }
    }
    
    if(trigger.isDelete){
        for(Contact con:Trigger.old){
            zendeskController.deleteAgent(con.Agent_Id__c);
        }
    }
}