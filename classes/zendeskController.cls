public class zendeskController {
    
    /**
     * Create ticket on salesforce to zendesk
     * @param zendeskId, this is salesforce unique id. 
     * @param subject, The value of the subject field for this ticket.
     * @param body, The comment on the ticket.
     * @param priority, The urgency with which the ticket should be addressed. Possible values: "urgent", "high", "normal", "low".
     * @param status, The state of the ticket. Possible values: "new", "open", "pending", "hold", "solved", "closed.
     * @param Type, The type of this ticket. Possible values: "problem", "incident", "question" or "task".
     * @param groupid, The group this ticket is assigned to.
     * @param reqestid, The user who requested this ticket.
    **/
    
    @future(callout=true)
    public static void createTicket(String zendeskId, String subject,String body,String status,String priority,String Type,String groupid,String requestid ){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket');
        req.setMethod('POST');
        String group_id;
        if(groupid!=null){
            List<Group__c> zenGroup = Data.read('select id,Group_Id__c from Group__c where id =:zenGroupId', new Map<String ,Object>{'zenGroupId' =>groupid});
            group_id=zenGroup[0].Group_Id__c;
            System.debug('groupSoql'+zenGroup[0].Group_Id__c);
        }else{group_id='+""'; }
        List<Contact>zenRequester = Data.read('select id,Zen_Agent_Id__c from Contact where id=:zenRequesterId',new Map<String,Object>{'zenRequesterId' =>requestid});
        String requester_id=zenRequester[0].Zen_Agent_Id__c;
        req.setBody('subject='+EncodingUtil.urlEncode(subject, 'UTF-8')+
                    '&body='+EncodingUtil.urlEncode(body, 'UTF-8')+
                    '&status='+EncodingUtil.urlEncode(status.toLowerCase(), 'UTF-8')+
                    '&priority='+EncodingUtil.urlEncode(priority.toLowerCase(), 'UTF-8')+
                    '&type='+EncodingUtil.urlEncode(type.toLowerCase(), 'UTF-8')+
                    '&group_id='+EncodingUtil.urlEncode(group_id, 'UTF-8')+
                    '&requester_id='+EncodingUtil.urlEncode(requester_id, 'UTF-8'));
        req.setCompressed(true); 
        try {
            res = http.send(req);
            Map<String,Object>responseMap=(Map<String,Object>)JSON.deserializeUntyped(res.getBody());
            Map<String,Object>ticketMap=(Map<String,Object>)responseMap.get('ticket');
            Integer ticketId=(Integer)ticketMap.get('id');
            zendeskUtility.updateZendesk(zendeskId,ticketId);
        } catch(System.CalloutException e) {
            System.debug(res.toString());
        }
    }
    
    /**
     * Update ticket on salesforce to zendesk
     * @param salesZenId, this is salesforce unique id.
     * @param str, what ever we want to update on ticket every thing store in str JSON.
    **/
    
    @future(callout=true)
    public static void updateTicket(String salesZenId,String str){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        String response=zendeskUtility.RequestHeader('PUT',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket',str);
        Map<String,Object>responseMap=(Map<String,Object>)JSON.deserializeUntyped(response);
        Map<String,Object>ticketMap=(Map<String,Object>)responseMap.get('ticket');
        Integer ticketId=(Integer)ticketMap.get('id');
        zendeskUtility.updateZendesk(salesZenId,ticketId);
    }
    
    /**
     * Delete ticket on salesforce to zendesk.
     * @param id, this is ticket id which ticket want to delete. 
    **/

    @future(callout=true)
    public static void deleteTicket(String id){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        String body='{"id":'+'"'+id+'"}';
        String response=zendeskUtility.RequestHeader('DELETE',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket', body);
    }
    
    /**
     * Create user on salesforce to zendesk.
     * @param userId, this is salesforce unique id.
     * @param name, The user's name.
     * @param email, The user's email.
     * @param role, The user's role like agent,end-user,admin.
    **/ 
    
    @future(callout=true)
    public static void createUser(String userId, String name,String email,String role){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        String body='{"name":'+'"'+name+'",'+'"email":'+'"'+email+'",'+'"role":'+'"'+role+'"}';
        String response=zendeskUtility.RequestHeader('POST',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',body);
        Map<String,Object>responseMap=(Map<String,Object>)JSON.deserializeUntyped(response);
        zendeskUtility.updateUser(responseMap,userId);
    }
    
    /**
     * update and delete user from salesforce to zendesk.
     * @param userId, This salesforce unique id.
     * @param userZenId, This zendesk user id.
     * @param name, This user's name.
     * @param role, The user's role like agent,end-user,admin. 
    **/
    
    @future(callout=true)
    public static void updateUser(String userId,String userZenId, String name,String role){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        User userRecord=[select id,Name,IsActive from User where Id=:userId];
        if(userRecord.IsActive){
            String body='{"id":'+'"'+userZenId+'",'+'"name":'+'"'+name+'",'+'"role":'+'"'+role+'"}';
            String response=zendeskUtility.RequestHeader('PUT',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',body);    
        }else{String body='{"id":'+'"'+userZenId+'"}';
            String response=zendeskUtility.RequestHeader('DELETE',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',body); 
        }
    }
    
    /**
     * update agent  from salesforce to zendesk.
     * @param userZenId, This zendesk agent id.
     * @param name, This agent's name.
     * @param role, The user's role like agent,end-user,admin. 
    **/
    
    @future(callout=true)
    public static void updateAgent(String userZenId, String name,String role){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        String body='{"id":'+'"'+userZenId+'",'+'"name":'+'"'+name+'",'+'"role":'+'"'+role+'"}';
        String response=zendeskUtility.RequestHeader('PUT',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',body);    
    }
    
    /**
     * Delete ticket on salesforce to zendesk.
     * @param agentId, This agent unique id which  want to delete. 
    **/
    
    @future (callout=true)
    public static void deleteAgent(String agentId){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        String body='{"id":'+'"'+agentId+'"}';
        String response=zendeskUtility.RequestHeader('DELETE',nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',body); 
    }
    
    /**
     * create ticket comment on salesforce.
     * @param comment, The comment on the ticket.
     * @param caseId, This salesforce unique id.
    **/
    
    public static void postComment(String comment,String caseId){
        System.debug('comment=='+comment);
            Case_Comment__c comm = new Case_Comment__c();
            comm.Name = comment.substring(0,6);
            comm.Comment__c = comment;
            comm.Case__c=caseId;
            comm.Zendesk_Record__c = false;
            Data.create(comm);
            
    }
    
    /**
     * preventNull method used in trigger and check null field.
     * @param field, Which field want to check.
    **/
    
    public static String preventNull(String field){
        if(field != null){
            return '+""';
        }
        return field;
    }
}