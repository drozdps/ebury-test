@isTest
public with sharing class TradeServiceTest {

    private static final Integer RECORD_NUMBER = 5;
    
    @isTest
    static void test_PopulateIDs_Positive() {
        List<Trade__c> trades = generateTrades(RECORD_NUMBER);

        Test.startTest();
        TradeService service = new TradeService(trades);
        service.populateIDs();
        Test.stopTest();

        for (Trade__c trade: trades) {
            System.assertNotEquals(null, trade.ID__c, 'Trade ID must be populated.');
            System.assertEquals(9, trade.ID__c.length(), 'Trade ID must contain exactly 9 characters.');
            System.assert(trade.ID__c.startsWith('TR'), ' Trade ID must start with "TR".');
        }
    }

    @isTest
    static void test_PopulateIDs_Negative() {
        List<Trade__c> trades = generateTrades(RECORD_NUMBER);
        for (Trade__c trade: trades) {
            trade.ID__c = 'TRAAA0000';
        }

        Test.startTest();
        TradeService service = new TradeService(trades);
        service.populateIDs();
        Test.stopTest();

        for (Trade__c trade: trades) {
            System.assertNotEquals(null, trade.ID__c, 'Trade ID must not be cleared.');
            System.assertEquals('TRAAA0000', trade.ID__c, ' Trade ID must not be changed by Apex trigger if it is already populated.');
        }
    }

    @isTest
    static void test_createChatterPosts_Negative() {
        List<Trade__c> trades = generateTrades(RECORD_NUMBER);

        Test.startTest();
        TradeService service = new TradeService(trades);
        try {
            service.createChatterPosts();
            System.assert(false, 'Execution flow must not reach this line.');
        } catch (UnsupportedOperationException exc) {
            System.assert(String.isNotBlank(exc.getMessage()), 'Appropriate error message must be returned.');
        }
        Test.stopTest();
    }

    private static List<Trade__c> generateTrades(Integer num) {
        List<Trade__c> trades = new List<Trade__c>();
        DateTime now = DateTime.now();
        for (Integer i = 0; i < num; i++) {
            trades.add(new Trade__c(SellAmount__c = num * 100.00, SellCurrency__c = 'USD',
                                    BuyCurrency__c = 'EUR', Rate__c = 1.00, BuyAmount__c = num * 100.00,
                                    DateBooked__c = now));
        }
        return trades;
    }
}
