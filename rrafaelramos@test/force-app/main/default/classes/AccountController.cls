/**
 * @author rrafaelramos
 */
public class AccountController {

    public static AccountService service;

    static {
        service = new AccountService();
    }

    @AuraEnabled(cacheable=true)
    public static Account getAccountInformation( String accountId ){

        try {

            Account account = service.getAccountInformation( accountId );

            return account;

        } catch ( Exception e ) {
            System.debug(e);
            throw new AuraHandledException('['+e.getTypeName()+':' + e.getLineNumber() + '] ' +e.getMessage());
        }
    }

    @AuraEnabled
    public static Account updateAccount( String name, String type, String accountNumber, String accountId ){

        try {

            Account account = service.updateAccount( name, type, accountNumber, accountId );

            return account;

        } catch ( Exception e ) {
            System.debug(e);
            throw new AuraHandledException('['+e.getTypeName()+':' + e.getLineNumber() + '] ' +e.getMessage());
        }
    }

}
