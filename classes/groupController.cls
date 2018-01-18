public class groupController {
    
    /**
     * Create group on salesforce to zendesk.
     * @param groupSobjId, This salesforce unique id.
     * @param name, This group name.
	**/
    
    @future (callout=true)
    public static void createGroup(String groupSobjId,String name){
            Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        	String body='{'+'"name":'+'"'+name+'"}';
            String response=zendeskUtility.RequestHeader('POST',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/group', body);
            Map<String,Object>resMap=(Map<String,Object>)JSON.deserializeUntyped(response);
            Map<String,Object>groupMap=(Map<String,Object>)resMap.get('group');
            String groupId=String.valueOf(groupMap.get('id'));
            zendeskUtility.updateGroupId(groupSobjId,groupId);      
    }
    
    /**
     * Update group on salesforce to zendesk.
     * @param groupId, This unique group id.
     * @param name, This group name.
	**/    
    
    @future (callout=true)
    public static void updateGroup(String groupId, String name){
           Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
           String body='{"groupId":'+'"'+groupId+'"'+','+'"name":'+'"'+name+'"'+'}';
           String response=zendeskUtility.RequestHeader('PUT',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/group', body);
    }
    
   /**
     * Delete group on salesforce to zendesk.
     * @param groupId, This unique group id.
	**/  
    
    @future (callout=true)
    public static void deleteGroup(String groupId){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        String body='{"id":'+'"'+groupId+'"}';
        String response=zendeskUtility.RequestHeader('DELETE',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/group', body);
    }
    
        
    /**
     * Create groupMemberShip on salesforce to zendesk.
     * @param salesGroupId, This salesforce unique id.
     * @param userId, This user's unique id.
     * @param groupId, This group unique id.
	**/
    
    @future(callout=true)
    public static void createGroupMemberShip(String salesGroupId,String userId,String groupId){ 
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        List<User>zenAgentId = Data.read('select id,Zendesk3Embed__zen_User_Id__c from User where id=:zenUserId',new Map<String,Object>{'zenUserId'=>userId});
        List<Group__c>zenGroupId = Data.read('select id,Zendesk3Embed__Group_Id__c from Zendesk3Embed__Group__c where id=:zenGroupId',new Map<String,Object>{'zenGroupId'=>groupId});
        String group_id=zenGroupId[0].Group_Id__c;
        String user_id=zenAgentId[0].zen_User_Id__c;
        String body='{"group_id":'+'"'+group_id+'"'+','+'"user_id":'+'"'+user_id+'"'+'}';
        String response=zendeskUtility.RequestHeader('POST',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/groupMembership', body);
        Map<String,Object>resMap=(Map<String,Object>)JSON.deserializeUntyped(response);
        Map<String,Object>groupMap=(Map<String,Object>)resMap.get('group_membership');
        String zenGroupMemberId=String.valueOf(groupMap.get('id'));
        zendeskUtility.updateGroupmemberId(salesGroupId,zenGroupMemberId);
    }
    
    
    /**
     * Delete groupMemberShip on salesforce to zendesk.
     * @param memberShipId, this unique agent's memberShipId
	**/
    
    @future (callout=true)
	    public static void deleteGroupMemberShip(String memberShipId){     
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        String body = '{"id":'+'"'+memberShipId+'"}';
        String response=zendeskUtility.RequestHeader('DELETE',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/groupMembership', body);
    } 
}