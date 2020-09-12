trigger Trade on Trade__c (before insert, after insert) {
    new TradeTriggerHandler().run();
}