import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import getAccountInformation from '@salesforce/apex/AccountController.getAccountInformation';
import updateAccount from '@salesforce/apex/AccountController.updateAccount';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_TYPE from '@salesforce/schema/Account.Type';

const DEFAULT_PLACEHOLDER = 'Selecione uma opção';
const DOCUMENT_OPTIONS = ['CPF','CNPJ'];
const CPF = 'CPF';
const CNPJ = 'CNPJ';

export default class AccountUpdate extends LightningElement{

    @api recordId;

    @track account = [];

    typePicklist = [];

    newAccountName;
    newAccountNumber;
    typeValue;

    isDocumentType = false;

    @wire( getAccountInformation,( { accountId: '$recordId' } ))
    wiredAccountInformation({ error, data }){

        if( data ){
            console.log( JSON.stringify( data ));
            this.account = [...data];

            if( data ) this.typeValue = data.Type;

        }

        if( error ){
            console.error( JSON.stringify( error ));
        }
    }

    @wire( getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountMetadata;

    @wire(getPicklistValues, { recordTypeId: '$accountMetadata.data.defaultRecordTypeId', fieldApiName: ACCOUNT_TYPE } )
    wiredTypePicklist( { error, data }){
        if( data ){

            let defaultValue = [{ label: DEFAULT_PLACEHOLDER, value: DEFAULT_PLACEHOLDER }];

            let values = [...data.values].map( item => {

                item = { label: item.label, value: item.value };

                return item;
            })

            this.typePicklist = [...defaultValue].concat(values);

            console.log( JSON.stringify(this.typePicklist));
        }

        if( error ){
            console.error( JSON.stringify( error ));
        }
    };

    handleNameChange( event ){

        if( !event ) return;

        event.stopImmediatePropagation();

        let name = event.target.value;

        this.newAccountName = name;
    }

    handleTypeChange( event ){

        if( !event ) return;

        event.stopImmediatePropagation();

        let type = event.target.value;

        if( !type || type === DEFAULT_PLACEHOLDER ) return;

        this.isDocumentType = DOCUMENT_OPTIONS.includes( type );

        this.typeValue = type;
    }

    handleAccountNumberChange( event ){

        if( !event ) return;

        event.stopImmediatePropagation();

        let value = event.target.value;

        if( !value ) return;

        if( this.typeValue === CPF && value.length > 11 ) event.target.value = event.target.value.slice(0, 11);

        if( this.typeValue === CNPJ && value.length > 14 ) event.target.value = event.target.value.slice(0, 14);

        this.newAccountNumber = value;
    }

    handleUpdateAccount( event ){

        if( !event ) return;

        event.stopImmediatePropagation();

        if( this.invalidFieldsToUpdate( ) ) return;

        let parameters = {
            name: this.newAccountName
            , type: this.typeValue
            , accountNumber: this.newAccountName
            , accountId: this.recordId
        };

        updateAccount( parameters ).then( result => {

            console.log( 'sucesso');

        }).catch( error => {
            console.error( error );
            this.isLoading = false;
        });

    }

    invalidFieldsToUpdate( ){

        return ( !this.newName || this.newName.length === 0 
                && this.typeValue === DEFAULT_PLACEHOLDER );        
    }

}