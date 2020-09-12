@isTest
public with sharing class ChatterServiceTest {
    
    @isTest
    static void test_AddPost_Positive() {
        Set<Id> recipients = new Set<Id>{UserInfo.getUserId()};
        String message = 'SOME_TEST_MESSAGE';
        Id subjectId = UserInfo.getUserId();

        ChatterService service;
        Test.startTest();
        service = new ChatterService();
        service.addPost(recipients, message, subjectId);
        Test.stopTest();

        System.assertEquals(1, service.inputs.size(), 'ChatterService must contain valid in-memory posts.');
    }

    @isTest
    static void test_Send_Negative() {
        Set<Id> recipients = new Set<Id>{UserInfo.getUserId()};
        String message = 'SOME_TEST_MESSAGE';
        Id subjectId = UserInfo.getUserId();

        ChatterService service = new ChatterService();
        service.addPost(recipients, message, subjectId);
        Test.startTest();
        try {
            service.send();
            System.assert(false, 'Execution flow must not reach this line.');
        } catch (UnsupportedOperationException exc) {
            System.assert(String.isNotBlank(exc.getMessage()), 'ConnectAPI error must be returned in a test context.');
        }
        Test.stopTest();
    }
}
