/**
 * @author rrafaelramos
 */
public class AccountEnricher {
    
    public Account withAccountNumberTypeAndName( Account account, String name, String type, String accountNumber ){

        account.Name = !String.isEmpty( name ) ? name : account.Name;
        account.Type = !String.isEmpty( type ) ? type : account.Type;
        account.AccountNumber = !String.isEmpty( accountNumber ) ? accountNumber : account.AccountNumber;

        return account;
    }

}
