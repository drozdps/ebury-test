/*
 *  Apex Controller for Trades List View component
 *  @author Paul Drozd
 *  @since 09-11-2020
 */
public with sharing class TradesController {

    @AuraEnabled(cacheable=true)
    public static List<Trade__c> getList(){
        return [SELECT Id, SellCurrency__c, SellAmount__c, BuyCurrency__c, 
                       BuyAmount__c, Rate__c, DateBooked__c
                FROM Trade__c WHERE ID__c != null ORDER BY DateBooked__c DESC];
    }

}
