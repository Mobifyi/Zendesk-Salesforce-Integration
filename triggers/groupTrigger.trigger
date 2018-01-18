trigger groupTrigger on Group__c (after insert,after update,after delete) {
    Map<Id,Schema.RecordTypeInfo>recordInfo=Schema.SObjectType.Group__c.getRecordTypeInfosById();    
    if(Trigger.isInsert){
        for(Group__c gr : Trigger.New){
            if(gr.Zendesk_Record__c == true){
                if(recordInfo.get(gr.RecordTypeId).getName()=='Group Membership'){
                    if(gr.User__c!= null && gr.Group__c != null){
                        groupController.createGroupMemberShip(gr.Id,gr.User__c,gr.Group__c);
                    }
                    }else{
                        groupController.createGroup(gr.Id,gr.Name);
                    }
                }
            }
        }

        if(Trigger.isUpdate){
            for(Group__c gr : Trigger.New){
                Group__c before = System.Trigger.oldMap.get(gr.Id);
                if(recordInfo.get(gr.RecordTypeId).getName()=='Group Membership'){
                    if(gr.Group_Member_Ship_Id__c!=null){
                        if(before.Group_Member_Ship_Id__c!=gr.Group_Member_Ship_Id__c && before.Group__c!=gr.Group__c){
                      // groupController.updateGroupMemberShip(gr.Group_Member_Ship_Id__c,gr.User__c,gr.Group__c);
                  }
              }
              }else{
                if(gr.Group_Id__c!=null){
                    if(before.Name!=gr.Name){
                     groupController.updateGroup(gr.Group_Id__c,gr.Name);
                 }
             }
         } 
                
     }
 }
    
    if(Trigger.isDelete){
        for(Group__c gr : Trigger.old){
            if(gr.Zendesk_Record__c == true){
                if(recordInfo.get(gr.RecordTypeId).getName()=='Group Membership'){
                    if(gr.Group_Member_Ship_Id__c != null){
                        groupController.deleteGroupMemberShip(gr.Group_Member_Ship_Id__c);
                    }
                }else{
                    groupController.deleteGroup(gr.Group_Id__c);
                } 
            }
        }
    }
    
}