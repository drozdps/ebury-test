/*
 * Service class for Trade-related operations
 * 
 * @author Pavel Drozd
 * @since 09-11-2020
 */
public with sharing class TradeService {

    // TO DO: move to Custom Settings / Custom Metadata Types, so that Queue name can be quickly changed
    private static final String TRADE_REVIEWER_QUEUE = 'Trade reviewers';
    private static final String ID_PREFIX = 'TR';
    private static final Integer ID_POSTFIX_LENGTH = 7;
    private static String idPatternString = ID_PREFIX + '[A-Z0-9]{'+ ID_POSTFIX_LENGTH +'}';

    private List<Trade__c> trades = new List<Trade__c>();

    public TradeService(List<Trade__c> trades) {
        this.trades = trades;
    }

    /*
     *  Checks whether ID__c values are populated.
     *  Typically ID__c is popoulated by JS code, but this method
     *  is needed in case when a new Trade__c is created not via the
     *  Lightning web component.
     */
    public void populateIDs() {
        Pattern idPattern = Pattern.compile(idPatternString);
        Boolean matches = true;
        for (Trade__c trade: this.trades) {
            matches = true;
            if (String.isNotBlank(trade.ID__c)) {
                matches = idPattern.matcher(trade.ID__c).matches();
            }
            if (String.isBlank(trade.ID__c) || !matches) {
                trade.ID__c = ID_PREFIX + generateRandomString(ID_POSTFIX_LENGTH);
            }
        }
    }

    public void createChatterPosts() {
        Set<Id> usersToNotify;
        try {
            usersToNotify = QueueSelector.getQueueMemberIds(TRADE_REVIEWER_QUEUE);
        } catch (QueryException exc) {
            trades[0].addError('Please check your org configuration. We cannot find "' + TRADE_REVIEWER_QUEUE + '" queue.');
        }
        try {
            ChatterService chatter = new ChatterService();
            for (Trade__c trade: this.trades) {
                chatter.addPost(usersToNotify, this.getPostMessage(trade), trade.Id); 
            }
            chatter.send();
        } catch(CustomException exc) {
            trades[0].addError('Cannot create Chatter post: ' + exc.getMessage());
        }
    }

    private String getPostMessage(Trade__c trade) {
        List<Object> params = new List<Object>{
            trade.SellCurrency__c, trade.SellAmount__c, 
            trade.BuyCurrency__c, trade.BuyAmount__c,
            trade.Rate__c, trade.DateBooked__c,
            URL.getSalesforceBaseUrl().toExternalForm() + '/' + trade.Id 
        };
        return String.format(Label.NewTradePostMessage, params);
    } 

    private static String generateRandomString(Integer length) {
        Blob blobKey = Crypto.generateAesKey(128);
        return EncodingUtil.convertToHex(blobKey).substring(0,length).toUpperCase();
    }
}
