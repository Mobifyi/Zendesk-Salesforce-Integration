public with sharing class ZenConfigController {
    public static Map<String, configVars> varsToShow {get; set;}
    public Static Boolean agentCollaps{get;set;}
    
    static {
        varsToShow = new Map<String, configVars>();
    }
    @AuraEnabled
    public static String initialize(){
        varsToShow.put('User', new configVars(0,0,0,'Not Started...'));
        varsToShow.put('Requester', new configVars(0,0,0,'Not Started...'));
        varsToShow.put('Group', new configVars(0,0,0,'Not Started...'));
        varsToShow.put('Ticket', new configVars(0,0,0,'Not Started...'));
        return JSON.serialize(varsToShow);
    }
    
    @AuraEnabled
    public Static String userZenToSales(){ 
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        if(!varsToShow.containsKey('User')){
           varsToShow.put('User', new configVars(0,0,0,'Not Started...')); 
        }
        String response=zendeskConfigUtility.getRequestHeader(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user/list');
        Map<String,object>resMap= (Map<String,object>)JSON.deserializeUntyped(response);
        List<Map<String,Object>>agentList=new List<Map<String,Object>>();
        for (Object instance :(List<Object>)resMap.get('users')){
            agentList.add((Map<String, Object>)instance);
        }
        
        List<User> zenAgent=[select id,zen_User_Id__c from User where zen_User_Id__c !=:null];
        varsToShow.get('User').alreadySync=zenAgent.size();
        Map<String,String>zenAgentMap=new Map<String,String>();
        for(User con: zenAgent){
            zenAgentMap.put(con.zen_User_Id__c,con.zen_User_Id__c);
        }
        Integer syncOfNumberUser=0;
        Map<Integer,Object>userMap = new Map<Integer,Object>();
        for(Integer i=0;i<agentList.size();i++){
            Long custId=(Long)agentList[i].get('id');
            String role=(String)agentList[i].get('role');
            String zenId=String.valueOf(custId);
            if(agentList[i].get('role')=='agent'){
                syncOfNumberUser++;
                if(!zenAgentMap.containsKey(zenId)){
                   userMap.put(i,(Object)agentList[i]);
                }
            }
        }

        varsToShow.get('User').totalSynched = syncOfNumberUser;
        List<User>allUser=new List<User>();
        for(Integer str:userMap.keySet()){
            User use=new User();
            Map<String,Object>customerMap=(Map<String,Object>)userMap.get(str);
            Long agentId=(Long)customerMap.get('id');
            String agId=String.valueOf(agentId);
            use.zen_User_Id__c =agId;
            use.Zendesk_Record__c = false;
            String agentName=(String)customerMap.get('name');
            List<String> userNameList=agentName.split(' ');
            if(userNameList.size()==1){
                use.FirstName=userNameList.get(0);
                use.LastName=userNameList.get(0);
                use.Alias=userNameList.get(0);
                use.CommunityNickname=userNameList.get(0);
            }
            if(userNameList.size()==2){
                use.FirstName=userNameList.get(0);
                use.LastName=userNameList.get(1);
                use.Alias=userNameList.get(0);
                use.CommunityNickname=userNameList.get(0);
            }
            if(userNameList.size()>=3){
                use.FirstName=userNameList.get(0);
                use.LastName=userNameList.get(1);
                use.Alias=userNameList.get(0);
                use.CommunityNickname=userNameList.get(1);
            }

            use.Email=(String)customerMap.get('email');
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User' LIMIT 1];
            use.ProfileId=profileId.id;
            use.Username=(String)customerMap.get('email');
            use.TimeZoneSidKey='GMT';
            use.LanguageLocaleKey='en_US';
            use.EmailEncodingKey='UTF-8';
            use.LocaleSidKey='en_US';
            allUser.add(use); 
        }
        
        if(allUser.size()==0){
            varsToShow.get('User').overallStatus='Up to date User from zendesk to salesforce';
        }
        
        if(allUser.size()>=1){
            if(Schema.sObjectType.User.isCreateable()){
                Database.SaveResult[] result = Database.insert(allUser,false);
                varsToShow.get('User').CreatedInSales=allUser.size();
                varsToShow.get('User').overallStatus='User record inserted in salesforce';
            }
        }
        return JSON.serialize(varsToShow.get('User'));
    }
    
    
    public void userSalesToZen(){
        
    }
    // agentZenToSales method zendesk user store in contact object for agent  
    @AuraEnabled
    public Static String agentZenToSales(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        if(!varsToShow.containsKey('Requester')){
           varsToShow.put('Requester', new configVars(0,0,0,'Not Started...')); 
        }
        String response=zendeskConfigUtility.getRequestHeader(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user/list');
        Map<String,object>resMap= (Map<String,object>)JSON.deserializeUntyped(response);
        List<Map<String,Object>>agentList=new List<Map<String,Object>>();
        for (Object instance :(List<Object>)resMap.get('users')){
            agentList.add((Map<String, Object>)instance);
        }
        //totalAgentSync=agentList.size();
        List<Contact> zenAgent=[select id,Zen_Agent_Id__c from Contact where Zen_Agent_Id__c !=:null];
        varsToShow.get('Requester').alreadySync=zenAgent.size();
        Map<String,String>zenAgentMap=new Map<String,String>();
        for(Contact con: zenAgent){
            zenAgentMap.put(con.Zen_Agent_Id__c,con.Zen_Agent_Id__c);
        }
        Map<Integer,Object>userMap = new Map<Integer,Object>();
        Integer endUser=0;
        for(Integer i=0;i<agentList.size();i++){
            Long custId=(Long)agentList[i].get('id');
            String role=(String)agentList[i].get('role');
            String zenId=String.valueOf(custId);
            if(agentList[i].get('role')=='end-user'){
                endUser++;
                if(zenAgentMap.containsKey(zenId)==false){
                     userMap.put(i,(Object)agentList[i]);
                }
            }
        }
        
        varsToShow.get('Requester').totalSynched=endUser;
        List<Contact>allContact=new List<Contact>();
        for(Integer str:userMap.keySet()){
            Contact con=new Contact();
            Map<String,Object>customerMap=(Map<String,Object>)userMap.get(str);
            Long agentId=(Long)customerMap.get('id');
            String agId=String.valueOf(agentId);
            con.Zen_Agent_Id__c=agId;
            con.Zendesk_Record__c = false;
            String agentName=(String)customerMap.get('name');
            List<String> agentNameList=agentName.split(' ');
            if(agentNameList.size()==1){
                con.LastName=agentNameList.get(0);
            }
            if(agentNameList.size()==2){
                con.Salutation=agentNameList.get(0);
                con.LastName=agentNameList.get(1);
            }
            if(agentNameList.size()>=3){
                con.Salutation=agentNameList.get(0);
                con.FirstName=agentNameList.get(1);
                con.LastName=agentNameList.get(2);
            }

            if((String)customerMap.get('email')==null){
                con.Email_Id__c=agentNameList.get(0)+agentNameList.get(1)+'@gmail.com';
            }
                con.Email_Id__c=(String)customerMap.get('email');
                con.Role__c=(String)customerMap.get('role');
                allContact.add(con);
        }
        if(allContact.size()==0){
            varsToShow.get('Requester').overallStatus='Up to date agent from zendesk to salesforce';
        }
        if(allContact.size()>=1){
            if(Schema.SObjectType.Contact.isCreateable()){
                varsToShow.get('Requester').CreatedInSales=allContact.size();
                Database.SaveResult[] result = Database.insert(allContact,false);
                varsToShow.get('Requester').overallStatus='Agent record inserted in salesforce';        
            }
        }
        return JSON.serialize(varsToShow.get('Requester'));
    }
    
    @AuraEnabled
    public static String groupsZenToSales(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        if(!varsToShow.containsKey('Group')){
           varsToShow.put('Group', new configVars(0,0,0,'Not Started...')); 
        }
        String allGroupsList=zendeskConfigUtility.getRequestHeader(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/groups');
        Map<String,Object>groupResponse=(Map<String,Object>)JSON.deserializeUntyped(allGroupsList);
        List<Map<String,Object>>listGroupMap=new List<Map<String,Object>>();
        for(Object instance: (List<Object>)groupResponse.get('groups')){
            listGroupMap.add((Map<String,Object>)instance);  
        } 
        varsToShow.get('Group').totalSynched=listGroupMap.size();
        Id groupRecordTypeId = Schema.SObjectType.Group__c.getRecordTypeInfosByName().get('Group').getRecordTypeId();
        List<Group__c> allSalesGroup=[select id,Group_Id__c from Group__c where RecordTypeId=:groupRecordTypeId];
        varsToShow.get('Group').alreadySync=allSalesGroup.size();
        Map<String,String>groupMap=new Map<String,String>();
        for(Group__c gro: allSalesGroup){
            groupMap.put(gro.Group_Id__c, gro.Group_Id__c);
        }
        
        
        List<Group__c>listGroup = new List<Group__c>();
        for(Integer i=0;i<listGroupMap.size();i++){
            Long groupId = (Long)listGroupMap[i].get('id');
            String groupName = (String)listGroupMap[i].get('name');
            String groId = String.valueOf(groupId);
            if(groupMap.containsKey(groId) == false){
                Group__c gr = new Group__c();
                gr.Group_Id__c = groId;
                gr.Zendesk_Record__c = false;
                gr.Name = groupName;
                gr.RecordTypeId = groupRecordTypeId;
                listGroup.add(gr);
            }
        }
        if(listGroup.size()== 0){
            varsToShow.get('Group').CreatedInSales = listGroup.size();
            varsToShow.get('Group').overallStatus = 'Up to date groups from zendesk to salesforce';
        }
        if(listGroup.size()>=1){
            if(Schema.SObjectType.Group__c.isCreateable()){
                varsToShow.get('Group').CreatedInSales = listGroup.size();
                Database.SaveResult[] result=Database.insert(listGroup,false);
                varsToShow.get('Group').overallStatus = 'Record Inserted in Salesforce';
            } 
        }
       return JSON.serialize(varsToShow.get('Group'));
    }
    
    @AuraEnabled
    public static String ticketZenToSales(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        if(!varsToShow.containsKey('Ticket')){
           varsToShow.put('Ticket', new configVars(0,0,0,'Not Started...')); 
        }
        String ticketRes=zendeskConfigUtility.getRequestHeader(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket');
        List<Object>ticketObj=(List<Object>)JSON.deserializeUntyped(ticketRes);
        List<Case> allTicketCase=[select id,Ticket_Id__c from Case where Ticket_Id__c!=:null];
        //allTicketCaseMap contains all Ticket_Id__c from salesfroce Case object
        Map<String,String>allTicketCaseMap=new Map<String,String>();
        for(Case ca: allTicketCase){
            allTicketCaseMap.put(ca.Ticket_Id__c,ca.Ticket_Id__c);
        }
        //allRequester map contains all Zen_Agent_Id__c from Contact object
        Map<String,String>allRequesterMap = new Map<String,String>();
        List<Contact>allAgentList=[select id,Zen_Agent_Id__c from Contact where Zen_Agent_Id__c!=:null]; 
        for(Contact con: allAgentList){
            allRequesterMap.put(con.Zen_Agent_Id__c,con.Zen_Agent_Id__c);
        }
        varsToShow.get('Ticket').alreadySync=allTicketCase.size();
        List<Case>allCaseData=new List<Case>();
        List<String>requ=new List<String>();
        Map<Integer,Object>TicketMap = new Map<Integer,Object>();
        Integer totalTicketSyncfromZendesk=0;
        for(Object obj: (List<Object>)ticketObj){
            totalTicketSyncfromZendesk++;
            Case caseData=new Case();
            Map<String,Object>tickMap=(Map<String,Object>)obj;
            Long ticketId=(Long)tickMap.get('id');
            String tickId=String.valueOf(ticketId);
            Long reqId=(Long)tickMap.get('requester_id');
            String rol=(String)tickMap.get('role');
            String requesterId=String.valueOf(reqId);
            requ.add(requesterId);
            if((allTicketCaseMap.containsKey(tickId))==false) {
                if(allRequesterMap.containsKey(requesterId)==true){
                    Contact agentId=[select id,Zen_Agent_Id__c from Contact where Zen_Agent_Id__c=:requesterId];
                    caseData.Requester__c=agentId.id;
                    caseData.Status=(String)tickMap.get('status');
                    caseData.Ticket_Id__c=tickId;
                    caseData.Zendesk_Record__c = false;
                    caseData.Origin=(String)tickMap.get('type');
                    caseData.Priority=(String)tickMap.get('priority');
                    caseData.Subject=(String)tickMap.get('subject');
                    caseData.Description=(String)tickMap.get('description');
                    allCaseData.add(caseData);
                }
            }
        }

        varsToShow.get('Ticket').totalSynched=totalTicketSyncfromZendesk;

        if(allCaseData.size() == 0){
            varsToShow.get('Ticket').CreatedInSales =0;
            varsToShow.get('Ticket').overallStatus='Up to date ticket from zendesk to salesforce';
        }

        if(allCaseData.size()>=1){
            if(Schema.SObjectType.Case.isCreateable()){
                varsToShow.get('Ticket').CreatedInSales=allCaseData.size();
                Database.SaveResult[] result=Database.insert(allCaseData, false);
                varsToShow.get('Ticket').overallStatus='Record Inserted in Salesforce';    
            }      
        }
        return JSON.serialize(varsToShow.get('Ticket'));
    }
     
    public void agentSalesToZen(){
        
    }
    public PageReference getUserPage(){
        PageReference pageRef = new PageReference('https://3embed-dev-ed.my.salesforce.com/005?isUserEntityOverride=1&retURL=%2Fui%2Fsetup%2FSetup%3Fsetupid%3DUsers&setupid=ManageUsers');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public PageReference getAgentPage(){
        PageReference pageRef = new PageReference('https://3embed-dev-ed.my.salesforce.com/003/o');
        pageRef.setRedirect(true);
        return pageRef;
        
    }
    public PageReference getTicketPage(){
        PageReference pageRef = new PageReference('https://3embed-dev-ed.my.salesforce.com/500/o');
        pageRef.setRedirect(true);
        return pageRef;
    }
    public PageReference getGroupPage(){
        PageReference pageRef = new PageReference('https://3embed-dev-ed.my.salesforce.com/a0T/o');
        pageRef.setRedirect(true);
        return pageRef;  
    }
    
	 private class configVars {
        Integer CreatedInSales;
        Integer totalSynched;
        Integer alreadySync;
        String overallStatus;
        configVars(Integer CreatedInSales, Integer totalSynched, Integer alreadySync, String overallStatus){
            this.CreatedInSales = CreatedInSales;
            this.totalSynched = totalSynched;
            this.alreadySync = alreadySync;
            this.overallStatus = overallStatus;
        }
    }    
}