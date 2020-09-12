/*
 * Service class for Trade-related operations
 * 
 * @author Pavel Drozd
 * @since 2020-05-20
 */
public with sharing class TradeService {

    private List<Trade__c> trades = new List<Trade__c>();

    public TradeService(List<Trade__c> trades) {
        this.trades = trades;
    }
}
