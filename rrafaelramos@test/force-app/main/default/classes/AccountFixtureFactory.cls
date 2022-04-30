/**
 * @author rrafaelramos
 */
@isTest
public class AccountFixtureFactory {
    
    static Map<String,Schema.RecordTypeInfo>  RECORD_TYPE_INFOS = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByDeveloperName();

    static String RECORDTYPE_PARTNER = RECORD_TYPE_INFOS.get('Partner').getRecordTypeId();
    static String RECORDTYPE_FINAL_CUSTOMER = RECORD_TYPE_INFOS.get('FinalCustomer').getRecordTypeId();

    public static Account newPartnerAccount() {
        return new Account(
            RecordTypeId = RECORDTYPE_PARTNER
            , Name = 'Parceiro'
            );
    }

    public static Account newFinalCustomerAccount() {
        return new Account(
            RecordTypeId = RECORDTYPE_FINAL_CUSTOMER
            , Name = 'Consumidor Final'
            );
    }

    public static Account createPartnerAccount( ){
        return createAccount( newPartnerAccount() );
    }

    public static Account createFinalCustomerAccount( ){
        return createAccount( newFinalCustomerAccount() );
    }

    public static Account newAccount( String recodTypeId ) {
        return new Account( RecordTypeId = recodTypeId );
    }

    public static Account createAccount( Account account ) {
        insert account;
        return account;
    }

}
