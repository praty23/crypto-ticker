public with sharing class CryptoTicker {

    private static final String URI = 'callout:Coinmarketcap';
    private static final String TOP_RESOURCE = '/v1/cryptocurrency/listings/latest';
    private static final String FAV_RESOURCE = '/v1/cryptocurrency/quotes/latest';

    public CryptoTicker() {

    }

    @AuraEnabled(cacheable=true)
    public static List<CryptoParser.Data> getCrypto(Integer topN){
        try {
            String queryString = URI + TOP_RESOURCE + '?start=1&limit=' + topN + '&convert=USD';
            /*******For future favorite implementation ************
            if(cryptoType == 'Top Cryptocurrencies'){
                queryString = URI + TOP_RESOURCE + '?start=1&limit=' + topN + '&convert=USD';
            } else if(cryptoType == 'Custom Favorites' && !(String.isBlank(symbols.trim()))){
                queryString = URI + FAV_RESOURCE + '?convert=USD&symbol=' + symbols;
            }
            ************************************************/
            system.debug(queryString); 
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            req.setMethod('GET');
            req.setEndpoint(queryString);
            req.setHeader('X-CMC_PRO_API_KEY', '{!$Credential.Password}');
            req.setHeader('Accept', 'application/json');
            try{
                HttpResponse res = http.send(req);
                if(res.getStatusCode()==200){
                    // system.debug(res.getBody());
                    // system.debug(JSON.deserializeUntyped(res.getBody()));
                    //system.debug(CryptoParser.parse(res.getBody()));
                    // FieldCreator.CryptoParser cp = CryptoParser.parse(res.getBody());
                    CryptoParser cp = CryptoParser.parse(res.getBody());
                    // system.debug('data=='+cp.data);
                    // for(FieldCreator.CryptoParser.Data data: cp.data){
                    for(CryptoParser.Data data: cp.data){
                        // system.debug('===Crypto Top Names===');
                        // system.debug('Name:' + data.name + ' Price: $' + data.quote.usd.price);
                    }
                    return cp.data;
                } else {
                    system.debug('Error occurred with response code ' + res.getStatusCode());
                    return null;
                }
            } catch (CalloutException ex){
                System.debug('Exception occured while making the callout ' + ex);
                throw new AuraHandledException(ex.getMessage());
            }

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    } 
}
