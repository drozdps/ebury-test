/*
 *  Apex controller for "New Trade" Lightning Web Component
 *  Uses FixerIO to pull relevant currency exchange rates.
 * 
 *  @author Paul Drozd
 *  @since 09-11-2020
 */
public with sharing class NewTradeController {
    
    @AuraEnabled
    public static FixerIO.ConvertResponse getConvertResult(String fromCurrency, String toCurrency, Decimal amount){
        try {
            FixerIO service = new FixerIO();
            return service.convert(fromCurrency, toCurrency, amount);
        } catch (CustomException exc) {
            throw new AuraHandledException(exc.getMessage());
        }
    }

}
