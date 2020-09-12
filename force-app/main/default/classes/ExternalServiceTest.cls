@isTest
public with sharing class ExternalServiceTest {
    

    @isTest
    static void test_FetchData_Positive() {
        System.assertEquals(null, ExternalService.services, 'CMT values must be fetched only on demand');

        Test.startTest();
        ExternalService.fetchData();
        Test.stopTest();

        System.assertNotEquals(null, ExternalService.services, 'CMT values must be fetched immediately after first reqest.');
    }

    @isTest
    static void test_getDefinition_Negative() {

        Test.startTest();
        try {
            CustomException exc = new CustomException('message');
            System.assert(String.isNotBlank(exc.getMessage()), 'Custom Exception must contain message.');
            ExternalService.getDefinition('SOME_INVALID_SERVICE');
            System.assert(false, 'Execution flow must never reach this line.');
        } catch (CustomException exc) {
            System.assert(exc.getMessage().contains('Invalid service configuration'),
                                'The service must return appropriate error');
        }
        Test.stopTest();
    }
}
