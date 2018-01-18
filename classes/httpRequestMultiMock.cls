public class httpRequestMultiMock implements HttpCalloutMock {
	Map<String, HttpCalloutMock> requests;

	public httpRequestMultiMock(Map<String, HttpCalloutMock> requests) {
		this.requests = requests;
	}

	public HTTPResponse respond(HTTPRequest req) {
		HttpCalloutMock mock = requests.get(req.getEndpoint());
		if (mock != null) {
			return mock.respond(req);
		} else {
            return mock.respond(req);
    			//throw new Exception('HTTP callout not supported for test methods');
		}
	}

	public void addRequestMock(String url, HttpCalloutMock mock) {
		requests.put(url, mock);
	}
}