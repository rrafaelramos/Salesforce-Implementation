import { LightningElement, api, track, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import getAccountInformation from '@salesforce/apex/AccountController.getAccountInformation';
import updateAccount from '@salesforce/apex/AccountController.updateAccount';

import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACCOUNT_TYPE from '@salesforce/schema/Account.Type';

const INVALID_ACCOUNT_NUMBER = 'Número do cliente é inválido';
const SUCCESS_MESSAGE = 'Conta atualizada com sucesso!';
const DEFAULT_PLACEHOLDER = 'Selecione uma opção';
const DOCUMENT_OPTIONS = ['CPF','CNPJ'];
const CPF = 'CPF';
const CNPJ = 'CNPJ';

export default class AccountUpdate extends LightningElement{

    @api recordId;

    @track account = [];
    typePicklist = [];

    isDocumentType = false;
    loader = false;

    newAccountName;
    newAccountNumber;
    typeValue;

    @wire( getAccountInformation,( { accountId: '$recordId' } ))
    wiredAccountInformation({ error, data }){

        if( data ){

            this.account = {...data};
            this.typeValue = data.Type;
            this.isDocumentType = DOCUMENT_OPTIONS.includes( data.Type );
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

        this.clearDocumentValueField();

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

        this.newAccountNumber = event.target.value;
    }

    handleAccountNumberBlur( event ){

        if( !event ) return;

        event.stopImmediatePropagation();

        let value = event.target.value;

        if( !value ) return;

        if( this.typeValue === CPF && value.length != 11 ) this.clearDocumentValueField();

        if( this.typeValue === CNPJ && value.length != 14 ) this.clearDocumentValueField();

        if( !Number( value ) ) this.clearDocumentValueField();
    }

    handleUpdateAccount( event ){

        if( !event ) return;

        event.stopImmediatePropagation();

        if( this.invalidFieldsToUpdate( ) ) return;

        if( DOCUMENT_OPTIONS.includes( this.typeValue ) ){

            if( !Number( this.newAccountNumber ) ) {
                this.clearDocumentValueField();
                return;
            }

        }

        this.loader = true;

        let parameters = {
            name: this.newAccountName
            , type: this.typeValue
            , accountNumber: this.newAccountNumber
            , accountId: this.recordId
        };

        updateAccount( parameters ).then( result => {

            this.showToast('Sucesso' , SUCCESS_MESSAGE, 'success' );

            this.loader = false;

        }).catch( error => {
            console.error( JSON.stringify(error) );
            this.loader = false;

            if( error.body.message.includes( INVALID_ACCOUNT_NUMBER ) ){
            
                this.showToast( 'Erro', INVALID_ACCOUNT_NUMBER, 'error' );
                return;
            }

            this.showToast( 'Erro:', this.buildErrorMessage( error ), 'error' );
        });

    }

    invalidFieldsToUpdate( ){
        return !this.newName && (!this.typeValue || this.typeValue === DEFAULT_PLACEHOLDER );        
    }

    clearDocumentValueField( ){

        let selector = this.template.querySelector('lightning-input[data-name="documentValue"]');
        
        if( selector ) selector.value = '';
    }

    showToast(title, message, variant) {

        const evtent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
        });

        this.dispatchEvent(evtent);
    }

    buildErrorMessage(error) {
        if (error.status)
            return `${error.status} (${error.statusText}) ${error.body ? '- ' + error.body.message : ''}.`

        return `${error.body ? '- ' + error.body.message : ''}`;
    }

}