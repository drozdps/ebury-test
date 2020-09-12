/*
 *  Apex class responsible for Salesforce -> Fixer.io communication.
 *  Used by Apex controllers to calculate actual exchange trade.
 * 
 *  @author Paul Drozd
 *  @since 09-11-2020
 */
public with sharing class FixerIO {
    
    public static final String SERVICE_NAME = 'FixerIO';
    
    private static final String HTTP_METHOD_GET = 'GET';
    private static final String CONVERT_URL = 'convert?access_key={0}&from={1}&to={2}&amount={3}';

    private ExternalService.Definition service;

    public FixerIO() {
        this.service = ExternalService.getDefinition(SERVICE_NAME);
    }

    /*
     * Performs convert operation
     * 
     * @param fromCurency From exchange currency
     * @param toCurrency To exchange currency
     * @param amount Amount to be converted
     * @throws CustomException Throws an exception when a service is misconfigured. 
     *                         The exception should be handled properly in a client code.
     */
    public ConvertResponse convert(String fromCurrency, String toCurrency, Decimal amount) {
        if (String.isBlank(fromCurrency) || String.isBlank(toCurrency) || amount == null) {
            throw new CustomException('Attempt to send bad parameters to Fixer.io.');
        }
        List<Object> params = new List<Object>{service.getToken(), fromCurrency, toCurrency, amount};
        String url = service.getURL() + String.format(CONVERT_URL, params);
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod(HTTP_METHOD_GET);

        HttpResponse response = (new Http()).send(request);
        
        if (response.getStatusCode() != 200) {
            throw new CustomException('Unable to get response from Fixer.io.');
        }
        ConvertResponse result = (ConvertResponse) JSON.deserialize(response.getBody(), ConvertResponse.class);

        if (!result.success) {
            throw new CustomException('Please, check your data. Fixer.io cannot process this request.');
        }

        return result;
    }

    public class ConvertResponse {
        @AuraEnabled public Boolean success;
        @AuraEnabled public Decimal result;
        @AuraEnabled public ConvertInfo info;

        public Decimal getResult() {
            return this.result;
        }

        public Decimal getRate() {
            return this.info == null ? 0 : this.info.rate;
        }
    }

    public class ConvertInfo {
        @AuraEnabled public Integer timestamp;
        @AuraEnabled public Decimal rate;
    }
}
