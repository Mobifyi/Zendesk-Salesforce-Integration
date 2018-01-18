global class zendeskCallOutMockTest implements HttpCalloutMock{
    global HttpResponse respond(HTTPRequest req){
        HttpResponse res = new HttpResponse();
        String body ='{"group":{"id":"114095758571","name":"testing group"}}';
        res.setHeader('Content-Type','application/text');
        res.setHeader('Accept','application/text');
        res.setBody(body);
        res.setStatus('OK');
        res.setStatusCode(200);
        return res;
    }
    
    global  class updateGroupTest implements HttpCalloutMock{
        global HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            String body ='{"group":{"id":"114095758571","name":"testing "}}';
            res.setHeader('Content-Type','application/text');
            res.setHeader('Accept','application/text');
            res.setBody(body);
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }
    
    global  class groupTestInmp implements HttpCalloutMock{
        
        global HttpResponse respond(HTTPRequest req){
            Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
            Http http = new Http();
            HttpResponse res = new HttpResponse();
            String body ='{"group":{"name":"testing ","id":"114095758571"}}';
            res.setHeader('Content-Type','application/text');
            res.setHeader('Accept','application/text');
            req.setEndpoint(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user');
            req.setMethod('POST');
            res.setBody(body);
            res.setStatus('OK');
            res.setStatusCode(200);
            res = http.send(req);
            return res;
        }
    }
    
    
    global class zendeskUser implements HttpCalloutMock{
        global HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            String body ='{"user":{"name":"3embed software","email":"3embed@mobifyi.com","organization_id":114134486251,"role":"end-user"}}';
            res.setHeader('Content-Type','application/text');
            res.setHeader('Accept','application/text');
            res.setBody(body);
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }
    
    global class zendeskUserUpdate implements HttpCalloutMock{//"id":115931999391,
        global HttpResponse respond(HTTPRequest req){
            HttpResponse res = new HttpResponse();
            String body ='{"user":{"name":"3embed software","email":"3embed@mobifyi.com","organization_id":114134486251,"role":"end-user"}}';
            res.setHeader('Content-Type','application/text');
            res.setHeader('Accept','application/text');
            res.setBody(body);
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }
    
      global class zendeskAgent implements HttpCalloutMock{
        global HttpResponse respond(HTTPRequest req){
            Zendesk3Embed__zendesk_url_address__c nodeUrl= Zendesk3Embed__zendesk_url_address__c.getInstance();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            String body ='{"user":{"name":"3embed software","email":"3embed@mobifyi.com","organization_id":114134486251,"role":"agent"}}';
            res.setHeader('Content-Type','application/text');
            res.setHeader('Accept','application/text');
            req.setEndpoint(nodeUrl.Zendesk3Embed__Node_Url__c+'/zendesk/user');
            req.setMethod('POST');
            res.setBody(body);
            res.setStatus('OK');
            res.setStatusCode(200);
            return res;
        }
    }
}