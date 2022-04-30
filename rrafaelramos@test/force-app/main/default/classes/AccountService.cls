/**
 * @author rrafaelramos
 */
public class AccountService {

    public AccountRepository repository;
    public AccountEnricher enricher;

    public AccountService(){
        this.repository = new AccountRepository();
        this.enricher = new AccountEnricher();
    }

    public Account getAccountInformation( String accountId ){

        Account account = repository.findById( accountId );

        return account;
    }

    virtual
    public Account updateAccount( String name, String type, String accountNumber, String accountId ){

        Account account = repository.findById( accountId );

        if( account == null ) return null;

        account = enricher.withAccountNumberTypeAndName( account, name, type, accountNumber );

        repository.save( account );

        return account;
    }

}
