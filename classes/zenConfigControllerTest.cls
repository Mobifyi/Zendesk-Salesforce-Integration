@isTest
public class zenConfigControllerTest {
	@isTest
    static void userZenToSalesTest(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Test.startTest();
        httpRequestMock getAllUserList=new httpRequestMock(200,
                                                          'Complete',
                                                          '{"users":[{"id":115823460414,"name":"Nagendra kumar singh","email":"nag@mobifyi.com","role":"admin","active":true},{"id":115824529954,"name":"Sample customer","email":"customer@example.com","role":"agent","active":true}]}',
                                                          null);
        Map<String, HttpCalloutMock> endpointMapResp =new Map<String,HttpCalloutMock>();
        endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user/list',getAllUserList);
        
        HttpCalloutMock multiCalloutMock = new httpRequestMultiMock(endpointMapResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ZenConfigController.userZenToSales();
		System.assertEquals(1,endpointMapResp.size());
        Test.stopTest();
    }
    
    @isTest
    static void agentZenToSalesTest(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Test.startTest();
        httpRequestMock getAllUserList=new httpRequestMock(200,
                                                          'Complete',
                                                          '{"users":[{"id":115823460414,"name":"Nagendra kumar singh","email":"nag@mobifyi.com","role":"admin","active":true},{"id":115824529954,"name":"Sample customer","email":"customer@example.com","role":"end-user","active":true}]}',
                                                          null);
        Map<String, HttpCalloutMock> endpointMapResp =new Map<String,HttpCalloutMock>();
        endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user/list',getAllUserList);
        
        HttpCalloutMock multiCalloutMock = new httpRequestMultiMock(endpointMapResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ZenConfigController.agentZenToSales();
		System.assertEquals(1,endpointMapResp.size());

        Test.stopTest();
    }
    //ticketZenToSales
     @isTest
    static void groupsZenToSalesTest(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Test.startTest();
        httpRequestMock getGroupsList=new httpRequestMock(200,
                                                          'Complete',
                                                          '{"groups":[{"id":114095585734,"name":"Support","deleted":false}]}',
                                                          null);
        Map<String, HttpCalloutMock> endpointMapResp =new Map<String,HttpCalloutMock>();
        endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/groups',getGroupsList);
        HttpCalloutMock multiCalloutMock = new httpRequestMultiMock(endpointMapResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        zenConfigController.groupsZenToSales();
		System.assertEquals(1,endpointMapResp.size());
        Test.stopTest();
    }
    
    @isTest
    static void ticketZenToSalesTest(){
        Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
        Test.startTest();
        httpRequestMock getTicketList = new httpRequestMock(200,
                                                          'Complete',
                                                          '[{"id":1,"type":"incident","subject":"Sample ticket: Meet the ticket","raw_subject":"Sample ticket: Meet the ticket","priority":"normal","status":"open","requester_id":115824529954,"submitter_id":115823460414,"assignee_id":115823460414,"group_id":114095585734},{"id":4,"type":"problem","subject":"salesforce ticket","raw_subject":"salesforce ticket","description":"salesforce body","priority":"normal","status":"pending","requester_id":115824529954,"submitter_id":115824529954,"assignee_id":115823460414,"group_id":114095585734}]',
                                                          null);
        Map<String, HttpCalloutMock> endpointMapResp = new Map<String,HttpCalloutMock>();
        endpointMapResp.put(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/ticket',getTicketList);
        HttpCalloutMock multiCalloutMock = new httpRequestMultiMock(endpointMapResp);
        Test.setMock(HttpCalloutMock.class, multiCalloutMock);
        ZenConfigController config = new ZenConfigController();
        ZenConfigController.ticketZenToSales();
        config.getUserPage();
        config.getAgentPage();
        config.getTicketPage();
        config.getGroupPage();
		System.assertEquals(1,endpointMapResp.size());

        Test.stopTest();
    }
}