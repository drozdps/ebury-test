/*
 * Apex trigger handler for Trade object
 * 
 * @author Pavel Drozd
 * @since 2020-05-20
 */
public with sharing class TradeTriggerHandler extends TriggerHandler {
    
    private List<Trade__c> newRecords;

    public TradeTriggerHandler() {
        this.newRecords = (List<Trade__c>) Trigger.new;
    }

    public override void beforeInsert() {
        TradeService service = new TradeService(newRecords);
        service.populateIDs();
    }

    public override void afterInsert() {
        TradeService service = new TradeService(newRecords);
        service.createChatterPosts();
    }
}
