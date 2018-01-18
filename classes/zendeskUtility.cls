public class zendeskUtility {
    /**
     * This method using every api call. 
     * @param method, we can define method POST,PUT and DELETE.
     * @param endpoint, define url,
     * @param body, contains every message. which message we want to send on url.
    **/
    
    public static String RequestHeader(String method,String endpoint,String body){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        req.setHeader('content-type','Application/json');
        req.setMethod(method);
        req.setBody(body);
        req.setEndpoint(endpoint);
        res=http.send(req);
        System.debug('req=='+req);
        System.debug('res=='+res);
        System.debug('res=='+res.getBody());
        return res.getBody();
    }

    
    /**
     * prepate JSON for ticket
     * @param TICKET_ID, this is salesforce unique id. 
     * @param subject, The value of the subject field for this ticket.
     * @param body, The comment on the ticket.
     * @param priority, The urgency with which the ticket should be addressed. Possible values: "urgent", "high", "normal", "low".
     * @param status, The state of the ticket. Possible values: "new", "open", "pending", "hold", "solved", "closed.
     * @param Type, The type of this ticket. Possible values: "problem", "incident", "question" or "task".
     * @param zenGroup, The group this ticket is assigned to.
     * @param requester, The user who requested this ticket.
    **/
    
    public static String ticketJson(String TICKET_ID, String subject,String body,String status,String priority,String Type,String zenGroup,String requester ){ 
        caseJson ticket1=new caseJson();
        ticket1.TICKET_ID=TICKET_ID;
        if(zenGroup!=null){
            List<Group__C>zenGroupId = Data.read('select id,Group_Id__c from Group__c where id =:zenGroupId',new Map<String,Object>{'zenGroupId' => zenGroup});
            ticket1.group_id=zenGroupId[0].Group_Id__c;
        }else{ticket1.group_id='undefine';}
        if(requester!=null){
            List<Contact> zenRequesterId = Data.read('select id,Zen_Agent_Id__c from Contact where id=:requesterId',new Map<String,Object>{'requesterId' => requester}); 
            ticket1.requester_id=zenRequesterId[0].Zen_Agent_Id__c;
        }else{ticket1.requester_id='undefine';}  
        ticket1.body=preventNull(body);
        ticket1.subject=subject;
        ticket1.status=status.toLowerCase();
        ticket1.priority=priority.toLowerCase();
        ticket1.Type=Type.toLowerCase();
        return JSON.serialize(ticket1);
    }

    
    /**
     * This method count how many times ticket comments
     * @param CaseID, This unique salesforce id. 
     * @param ticketId, This ticket id.
    **/
    
    public static void updateZendesk(String CaseID,Integer ticketId){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Integer commentNo;
        if(ticketId!=null){
            String commentCount=zendeskConfigUtility.getRequestHeader(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket/comments/'+ticketId);
            Map<String,Object>responseMap=(Map<String,Object>)JSON.deserializeUntyped(commentCount);
            commentNo=(Integer)responseMap.get('count');
        }
        Case cas=new Case();
        cas.Id=CaseID;
        cas.Ticket_Id__c=String.valueOf(ticketId);
        cas.Comment_Count__c=String.valueOf(commentNo);
        cas.Zendesk_Record__c=false;
        Data.modify(cas);
    } 
    
    /**
     * Update User's from salesforce to zendesk.
     * @param responseMap, Map contains what ever's response comes from zendesk
     * @param userId, This salesforce unique id.
    **/
    
    public static void updateUser(Map<String,Object>responseMap,String userId){
        Map<String,Object>UserMap=(Map<String,Object>)responseMap.get('user');
        Long AgentId=(Long)UserMap.get('id');
        String ageId=String.valueOf(AgentId);
        String role=(String)UserMap.get('role');
        if(role=='end-user'){
            Contact con=new Contact();
            con.id=userId;
            con.Zen_Agent_Id__c=ageId;
            con.Zendesk_Record__c=true;
            Data.modify(con);
        }else{
            User use=new User();
            use.id=userId;
            use.zen_User_Id__c=ageId;
            Data.modify(use);
        }
    }
    /**
     * Update group Id when group is create after that group id update on Group__c object.
     * @param groupAccID, This salesforce unique id.
    **/
        public static void updateGroupId(String groupId,String groupAccID){
        Group__c gro=new Group__c();
        gro.RecordTypeId=Schema.SObjectType.Group__c.RecordTypeInfosByName.get('Group').RecordTypeId;
        gro.Id=groupId;
        gro.Group_Id__c=groupAccID;        
        Data.modify(gro);
    }

    /**
     * Update updateGroupmemberId Id when groupMemberShip is create after that groupMemberShip id update on Group__c object.
     * @param zenGroupMemberId, This salesforce unique id.
    **/
    
    public static void updateGroupmemberId(String groupId,String zenGroupMemberId){
        Group__c gro=new Group__c();
        gro.RecordTypeId=Schema.SObjectType.Group__c.RecordTypeInfosByName.get('Group Membership').RecordTypeId;
        gro.Id=groupId;
        gro.Group_Member_Ship_Id__c=zenGroupMemberId;        
        Data.modify(gro);
    }
    
   /**
     * preventNull method used in check null field.
     * @param field, Which field want to check.
    **/
    public static String preventNull(String field){
        if(field==null){
            return ' ';
        }else{
            return field;
        }
    }
}