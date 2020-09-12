/*
 *  Static service which fetches details about external systems
 *  from Custom Metadata Type "ExternalService__mdt"
 * 
 *  @author Paul Drozd
 *  @since 09-11-2020
 */
public with sharing class ExternalService {
    
    // Static collection for in-memory caching
    private static Map<String, ExternalService.Definition> services;

    public static ExternalService.Definition getDefinition(String serviceName) {
        if (services == null) {
            fetchData();
        }
        ExternalService.Definition def = services.get(serviceName);
        if (def == null || String.isBlank(def.getToken()) || String.isBlank(def.getURL())) {
            throw new CustomException('Invalid service configuration for ' + serviceName);
        }
        return def;
    }

    private static void fetchData() {
        services = new Map<String, ExternalService.Definition>();
        for (ExternalService__mdt service: [SELECT URL__c, Token__c, MasterLabel
                                            FROM ExternalService__mdt WHERE URL__c != null]) {
            ExternalService.Definition def = new ExternalService.Definition(service.MasterLabel, service.URL__c, service.Token__c);
            services.put(def.getName(), def);
        }
    }
    
    
    public class Definition {

        private String name;
        private String URL;
        private String token;

        public Definition(String name, String URL, String token) {
            this.name = name;
            this.URL = URL;
            this.token = token;
        }

        public String getURL() {
            return this.URL;
        }

        public String getToken() {
            return this.token;
        }

        public String getName() {
            return this.name;
        }
    }
}
