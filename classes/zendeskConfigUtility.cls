public class zendeskConfigUtility {   
    /**
     * get Data from zendesk to salesforce.
     * @param endPoint, set endpoint 
	**/
    public static String getRequestHeader(String endPoint){
        HttpRequest req = new HttpRequest();
        HttpResponse res = new HttpResponse();
        Http http = new Http();
        req.setEndpoint(endPoint);
        req.setHeader('content-type','Application/json');
        req.setMethod('GET');      
        res = http.send(req);
        String resp=res.getBody();
        return resp;
    }
}