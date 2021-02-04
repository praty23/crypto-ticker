public with sharing class CryptoParser {
    /***************************************
     * Generated using JSON2Apex utility
     * Please ensure to annotate the variables 
     * as @AuraEnabled to use them in your component
     **************************************/
    public CryptoParser() {

    }

    public class Status {
		public String timestamp;
		public Integer error_code;
		public String error_message;
		public Integer elapsed;
		public Integer credit_count;
		public String notice;
		public Integer total_count;
	}

	public class Quote {
		@AuraEnabled public USD usd {get;set;}
	}

	public Status status;
	public List<Data> data;

	public class Platform {
		public Integer id;
		public String name;
		public String symbol;
		public String slug;
		public String token_address;
	}

	public class USD {
		@AuraEnabled public Double price{get; set;}
		public Double volume_24h;
		public Double percent_change_1h;
		@AuraEnabled public Double percent_change_24h;
		public Double percent_change_7d;
		public Double percent_change_30d;
		public Double market_cap;
		public String last_updated;
	}

	public class Data {
		@AuraEnabled public Integer id {get;set;}
		@AuraEnabled public String name {get;set;}
		@AuraEnabled public String symbol;
		public String slug;
		public Integer num_market_pairs;
		public String date_added;
		public List<String> tags;
		public Double max_supply;
		public Double circulating_supply;
		public Double total_supply;
		public Platform platform;
		public Integer cmc_rank;
		public String last_updated;
		@AuraEnabled public Quote quote {get;set;}
	}

	
	public static CryptoParser parse(String json) {
		return (CryptoParser) System.JSON.deserialize(json, CryptoParser.class);
	}
}
