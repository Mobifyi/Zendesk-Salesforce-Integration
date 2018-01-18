@isTest
public class zendeskTest {
    @isTest
    static void groupCrud()
    {
        Test.startTest();        
        Test.setMock(HttpCalloutMock.class, new zendeskCallOutMockTest()); 
        Id groupRecordTypeId = Schema.SObjectType.Group__c.getRecordTypeInfosByName().get('Group').getRecordTypeId();
        Group__c gr=new Group__c();
        gr.Name='testing group';
        gr.Zendesk_Record__c=true;
        gr.RecordTypeId=groupRecordTypeId;
        insert gr;
        
        Test.setMock(HttpCalloutMock.class, new zendeskCallOutMockTest.updateGroupTest()); 
        groupController.updateGroup(gr.Group_Id__c,'test');
        groupController.deleteGroup(gr.Group_Id__c);
        System.assertEquals('testing group',gr.Name);
        Test.stopTest();
    }
    
    @isTest
    static void agentTest(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new zendeskCallOutMockTest.zendeskUser()); 
        Contact con = new Contact();        
        con.FirstName='3embed';
        con.LastName='software';
        con.Email_Id__c='3embed@mobifyi.com';
        con.Role__c='end-user';
        con.Zendesk_Record__c=true;
        insert con;

        Test.setMock(HttpCalloutMock.class, new zendeskCallOutMockTest.zendeskUserUpdate());       
        zendeskController.updateAgent(con.Zen_Agent_Id__c,'3embed software ','end-user');
        zendeskController.deleteAgent(con.Zen_Agent_Id__c);
        System.assertEquals('3embed',con.FirstName);
        Test.stopTest();
              
    }    
    
    @isTest
    static void UserTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new zendeskCallOutMockTest.zendeskAgent()); 
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User' LIMIT 1];
            User use =new User();
            use.FirstName='Nagendra';
            use.LastName='kumar';
            use.Alias='nks';
            use.Zendesk_Record__c = false;
            use.CommunityNickname='nks@nagendra';
            use.ProfileId=profileId.id;
            use.Email='nag@mobifyi.com';
            use.Username='nag1254@mobifyi.com';
            use.IsActive=true;
            use.TimeZoneSidKey='GMT';
            use.LanguageLocaleKey='en_US';
            use.EmailEncodingKey='UTF-8';
            use.LocaleSidKey='en_US';
            insert use;
        
            zendeskController.updateUser(use.Id,use.zen_User_Id__c,'3embed software','agent');
        	System.assertEquals('Nagendra',use.FirstName);
        Test.stopTest(); 
    }
    
    @isTest
    static void userUpdateTest(){
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new zendeskCallOutMockTest.zendeskAgent()); 
            Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User' LIMIT 1];
            User use =new User();
            use.FirstName='Nagendra';
            use.LastName='kumar';
            use.Alias='nks';
            use.Zendesk_Record__c = true;
            use.CommunityNickname='nks@nagendra';
            use.ProfileId=profileId.id;
            use.Email='nag@mobifyi.com';
            use.Username='nag1254@mobifyi.com';
            use.IsActive=false;
            use.TimeZoneSidKey='GMT';
            use.LanguageLocaleKey='en_US';
            use.EmailEncodingKey='UTF-8';
            use.LocaleSidKey='en_US';
            insert use;
            zendeskController.updateUser(use.Id,use.zen_User_Id__c,'3embed software','agent');
        	System.assertEquals('Nagendra',use.FirstName);
        Test.stopTest();
    }
    
    @isTest
    static void createGroupMemberShipTest(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Test.startTest();        
            httpRequestMock groupResponse=new httpRequestMock(200,
                                                         'Complete',
                                                         '{"group":{"name":"testing ","id":"114095758571"}}',
                                                         null);
           httpRequestMock userResponse=new httpRequestMock(200,
                                                         'Complete',
                                                         '{"user":{"id":116266797311,"name":"3embed software","email":"3embed@mobifyi.com","organization_id":114134486251,"role":"agent"}}',
                                                         null);
            httpRequestMock groupMemberShipRes=new httpRequestMock(200,
                                                         'Complete',
                                                         '{"group_membership":{"url":"https://3embed.zendesk.com/api/v2/group_memberships/114097945791.json","id":114097945791,"user_id":116266797311,"group_id":114095758571,"default":false}}',
                                                         null);
        

       		Map<String, HttpCalloutMock> endpointMapResp =new Map<String,HttpCalloutMock>();
        	endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/group',groupResponse);
            endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',userResponse);
            endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/groupMembership',groupMemberShipRes);

        	HttpCalloutMock multiCalloutMock = new httpRequestMultiMock(endpointMapResp);
			Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
           Id groupRecordTypeId = Schema.SObjectType.Group__c.getRecordTypeInfosByName().get('Group').getRecordTypeId();

            Group__c gr=new Group__c();
            gr.Name='testing';
        	gr.Zendesk_Record__c=true;
            gr.RecordTypeId=groupRecordTypeId;
            insert gr;
        
           Profile profileId = [SELECT Id FROM Profile WHERE Name = 'Chatter Free User' LIMIT 1];
            User use = new User();
            use.FirstName='3embed';
            use.LastName='software';
            use.Alias='nks';
            use.Zendesk_Record__c = true;
            use.CommunityNickname='nks@nagendra';
            use.ProfileId=profileId.id;
            use.Email='3embed@mobifyi.com';
            use.Username='nag1254@mobifyi.com';
            use.IsActive=false;
            use.TimeZoneSidKey='GMT';
            use.LanguageLocaleKey='en_US';
            use.EmailEncodingKey='UTF-8';
            use.LocaleSidKey='en_US';
            insert use;
        
            Id groupRecordTypeId2 = Schema.SObjectType.Group__c.getRecordTypeInfosByName().get('Group Membership').getRecordTypeId();
            Group__c gr2=new Group__c();
            gr2.Name='testing group';
            gr2.RecordTypeId=groupRecordTypeId2;
            gr2.Group__c=gr.Id;
            gr2.User__c=use.id;
        	gr2.Zendesk_Record__c=true;
            insert gr2;
        	groupController.deleteGroupMemberShip(gr.Group_Member_Ship_Id__c);
        	System.assertEquals('testing group',gr2.Name);
        	
            
          test.stopTest();
    }
    
    
       @isTest
    static void updateTicketTest(){     
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Test.startTest();        
        httpRequestMock groupResponse=new httpRequestMock(200,
                                                          'Complete',
                                                          '{"group":{"name":"testing ","id":"114095635473"}}',
                                                          null);
        httpRequestMock userResponse=new httpRequestMock(200,
                                                         'Complete',
                                                         '{"user":{"id":115843512493,"name":"3embed software","email":"3embed@mobifyi.com","organization_id":114134486251,"role":"end-user"}}',
                                                         null);
        httpRequestMock ticketRes=new httpRequestMock(200,
                                                         'Complete',
                                                          '{"ticket":{"url":"https://mobifyi.zendesk.com/api/v2/tickets/3.json","type":"task","subject":"testing ticket","raw_subject":"testing ticket","description":"hello body","priority":"high","status":"open","recipient":null,"requester_id":115823460414,"submitter_id":115823460414,"assignee_id":115823460414,"organization_id":116493087134,"group_id":114095585734}}',
                                                           null);
        

       		Map<String, HttpCalloutMock> endpointMapResp =new Map<String,HttpCalloutMock>();
        	endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/group',groupResponse);
            endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',userResponse);
            endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket',ticketRes);

        	HttpCalloutMock multiCalloutMock = new httpRequestMultiMock(endpointMapResp);
			Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
            Id groupRecordTypeId = Schema.SObjectType.Group__c.getRecordTypeInfosByName().get('Group').getRecordTypeId();

            Group__c gr=new Group__c();
            gr.Name='testing';
            gr.RecordTypeId=groupRecordTypeId;
        	gr.Zendesk_Record__c=true;
            insert gr;
                
            Contact con = new Contact();        
            con.FirstName='3embed';
            con.LastName='software';
            con.Email_Id__c='3embed@mobifyi.com';
            con.Role__c='end-user';
            con.Zendesk_Record__c=true;
            insert con;
        	
            Case ca=new Case();
            ca.Group__c=gr.Id;
            ca.ContactId=con.Id;
            ca.Status='open';
            ca.Origin='problem';
            ca.Priority='low';
            ca.Subject='testing event';
            ca.Description='hello how are u';
            ca.Zendesk_Record__c=true;
        	insert ca;
        
        	Case_Comment__c comment =new Case_Comment__c();
        	comment.Name='Testing comment';
        	comment.Case__c=ca.Id;
        	comment.Zendesk_Record__c=false;
        	Comment.Comment__c='hello comment';
        	insert comment;
        
        	String body='{"ticket":{"id":3,"type":"task","subject":"testing ticket","raw_subject":"testing ticket","description":"hello body","priority":"high","status":"open","recipient":null,"requester_id":115823460414,"group_id":114095585734}}';
			zendeskController.updateTicket(ca.Id,body);
        	zendeskController.deleteTicket('4');
			System.assertEquals('testing',gr.Name);
        Test.stopTest();        
    }  
    
    @isTest
    static void createTicketTest(){   
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Test.startTest();        
        httpRequestMock groupResponse=new httpRequestMock(200,
                                                          'Complete',
                                                          '{"group":{"name":"testing ","id":"114095635473"}}',
                                                          null);
        httpRequestMock userResponse=new httpRequestMock(200,
                                                         'Complete',
                                                         '{"user":{"id":115843512493,"name":"3embed software","email":"3embed@mobifyi.com","organization_id":114134486251,"role":"end-user"}}',
                                                         null);
        httpRequestMock ticketRes=new httpRequestMock(200,
                                                         'Complete',
                                                          '{"ticket":{"url":"https://mobifyi.zendesk.com/api/v2/tickets/3.json","type":"task","subject":"testing ticket","raw_subject":"testing ticket","description":"hello body","priority":"high","status":"open","recipient":null,"requester_id":115823460414,"submitter_id":115823460414,"assignee_id":115823460414,"organization_id":116493087134,"group_id":114095585734}}',
                                                           null);
        

       		Map<String, HttpCalloutMock> endpointMapResp =new Map<String,HttpCalloutMock>();
        	endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/group',groupResponse);
            endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user',userResponse);
            endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket',ticketRes);

        	HttpCalloutMock multiCalloutMock = new httpRequestMultiMock(endpointMapResp);
			Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        
            Id groupRecordTypeId = Schema.SObjectType.Group__c.getRecordTypeInfosByName().get('Group').getRecordTypeId();

            Group__c gr=new Group__c();
            gr.Name='testing';
            gr.RecordTypeId=groupRecordTypeId;
        	gr.Zendesk_Record__c=true;
            insert gr;
                
            Contact con = new Contact();        
            con.FirstName='3embed';
            con.LastName='software';
            con.Email_Id__c='3embed@mobifyi.com';
            con.Role__c='end-user';
            con.Zendesk_Record__c=true;
            insert con;
        	
            Case ca=new Case();
            ca.Group__c=gr.Id;
            ca.ContactId=con.Id;
            ca.Status='open';
            ca.Origin='problem';
            ca.Priority='low';
            ca.Subject='testing event';
            ca.Description='hello how are u';
            ca.Zendesk_Record__c=true;
        	insert ca;
        
        	ca.Description='hello how are u sir';
        	ca.Ticket_Id__c='30';
            ca.Zendesk_Record__c=true;
            ca.Group__c=gr.Id;
            ca.ContactId=con.Id;
            ca.Status='open';
            ca.Origin='problem';
            ca.Priority='low';
            ca.Subject='testing event';

        	update ca;
        
        	Case_Comment__c comment =new Case_Comment__c();
        	comment.Name='Testing comment';
        	comment.Case__c=ca.Id;
        	comment.Zendesk_Record__c=false;
        	Comment.Comment__c='hello comment';
        	insert comment;
        
        	String body='{"ticket":{"id":3,"type":"task","subject":"testing ticket","raw_subject":"testing ticket","description":"hello body","priority":"high","status":"open","recipient":null,"requester_id":115823460414,"group_id":114095585734}}';
			zendeskController.updateTicket(ca.Id,body);
			System.assertEquals('testing',gr.Name);
        Test.stopTest();        
    }    
     
    @isTest
    static void preventNullTest(){
        String str='hello';
        zendeskController.preventNull(str);
    }
    
    @isTest
        static  void testCon(){
        Tab_Con controller = new Tab_Con ();
        System.assertNotEquals(Null,controller.randomSuffix);
    }
    
    @isTest
    static void testCase(){
        Cases cas = new Cases();
        Cases.sessionId();
        Cases.init();
    }
}