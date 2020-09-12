@isTest
public with sharing class NewTradeControllerTest {
    
    @isTest
    static void test_GetConvertResults_Positive() {
        // since we cannot deploy CMT in Apex tests, we will store them in-memory
        ExternalService.Definition service = new ExternalService.Definition(FixerIO.SERVICE_NAME, 'http://fixer.io/', 'token');
        ExternalService.services = new Map<String, ExternalService.Definition>{
            FixerIO.SERVICE_NAME => service
        };

        FixerIO.ConvertResponse response;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FixerIOMock());
        response = NewTradeController.getConvertResult('USD', 'EUR', 1.00);
        Test.stopTest();

        System.assertNotEquals(null, response, 'Valid response msut be returned.');
        System.assertEquals(100, response.result, 'Response must invclude proper result.');
        System.assertEquals(3.1415, response.getRate(), 'Rate must be populated.');
        System.assertEquals(100, response.getResult(), 'Result must be populated.');

    }

    @isTest
    static void test_GetConvertResults_Negative() {
        FixerIO.ConvertResponse response;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new FixerIOMock());
        try{
            response = NewTradeController.getConvertResult('USD', 'EUR', 99);
            System.assert(false, 'Execution flow must not reach this line: exception must be thrown.');
        } catch (AuraHandledException exc) {
            System.assert(String.isNotBlank(exc.getMessage()),
                          'AuraHandledException with meaningful description must be thrown');
        }
        Test.stopTest();
    }

    public class FixerIOMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            if (!req.getEndpoint().contains('/convert')) {
                throw new AssertException('Request to Fixer.io must use conversion endpoint');
            }
            FixerIO.ConvertResponse response = new FixerIO.ConvertResponse();
            FixerIO.ConvertInfo info = new FixerIO.ConvertInfo();
            info.rate = 3.1415;
            info.timestamp = 1599932941;
            response.info = info;
            HttpResponse res = new HttpResponse();
            if (!req.getEndpoint().contains('99')) {
                response.success = true;
                response.result = 100;
                res.setStatusCode(200);
            } else {
                response.success = false;
                response.result = null;
                res.setStatusCode(404);
            }
            res.setBody(JSON.serialize(response));
            return res;
        }
    }
}
