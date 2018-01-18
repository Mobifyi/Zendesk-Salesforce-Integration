trigger UserTrigger on User (after insert, after update) {
String fullName;
    if(Trigger.isInsert){
        for(User us: Trigger.New){
            if(us.Zendesk_Record__c == true){
                if(us.FirstName == null){
                    fullName=us.LastName;
                }else{
                    fullName=us.FirstName+' '+us.LastName;
                }
                zendeskController.createUser(us.Id,fullName,us.Email,'agent');               
            }
        }
    }
    
    if(Trigger.isUpdate){
        for(User us: Trigger.New){
            User oldUser = Trigger.oldMap.get(us.Id);
            if(us.zen_User_Id__c!=null){
                if(oldUser.FirstName!=us.FirstName || oldUser.LastName!= us.LastName || oldUser.IsActive!= us.IsActive){
                    System.debug('isActive');
                if(us.FirstName == null){
                    fullName=us.LastName;
                }else{
                    fullName=us.FirstName+' '+us.LastName;
                }
                	zendeskController.updateUser(us.Id,us.zen_User_Id__c, fullName,'agent');  
                }
            }
        }
    }
}