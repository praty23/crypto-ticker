import { LightningElement, wire, api} from 'lwc';
import getTopCrypto from '@salesforce/apex/CryptoTicker.getCrypto';
import {refreshApex} from '@salesforce/apex';

const COLUMNS = [
    {label: 'Name', fieldName: 'Name', type: 'text' },
    {label: 'Price', fieldName: 'Price', type: 'number'}
];

export default class CryptoTicker extends LightningElement {
    cryptoList = [];
    returnedCrypto;
    @api showHeader;
    @api autoRefresh;
    @api refreshRate;
    // @api favoriteCrypto;
    @api headerTitle;
    @api topN
    columns = COLUMNS;
    error;
    intervalId;

    // isTopCrypto;
    // isCustomFav;

    /*****To be implemented ****
    @api set cryptoType(value) {
        this.isTopCrypto = value === 'Top Cryptocurrencies';
        this.isCustomFav = value === 'Custom Favorites';
    }
    get cryptoType() {
        return this.isTopCrypto? 'Top Cryptocurrencies': this.isCustomFav? 'Custom Favorites': '';
    }
    *****************************/

    @wire(getTopCrypto, {topN: '$topN'}) wiredResult(result){
        if(result.data){
            this.returnedCrypto = result;
            let topCryptos = [];
            result.data.forEach(element => {
                let crypto = {};
                crypto.Name = element.name + ' (' + element.symbol + ')';
                crypto.Price = element.quote.usd.price;
                crypto.PercentChange = element.quote.usd.percent_change_24h;
                crypto.Id = element.id;
                crypto.ColorChange = crypto.PercentChange>0?'classIncrease':'classDecrease';
                crypto.Change = crypto.PercentChange>0?'utility:up':'utility:down';
                topCryptos.push(crypto);
            });
            console.log('res==', topCryptos);
            this.cryptoList = topCryptos;
            this.refreshTicker();
        } else {
            this.error = result.error;
            console.log('error occurred ' + this.error);
        }
    }

    connectedCallback(){
        // console.log('rconnectedCallback==', this.cryptoList, this.autoRefresh);
    }

    refreshTicker(){
        if (this.autoRefresh){
            this.intervalId = setInterval(()=>{
                this.getLatestPrices()
            }, 60000 * this.refreshRate);
        } else {
            clearInterval(this.intervalId);
        }
    }

    getLatestPrices(){
        refreshApex(this.returnedCrypto);
    }
    
}