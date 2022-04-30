/**
 * @author rrafaelramos
 */
public class AccountService {

    public AccountFilter filter;
    public AccountEnricher enricher;
    public AccountRepository repository;

    public AccountService(){
        this.filter = new AccountFilter();
        this.enricher = new AccountEnricher();
        this.repository = new AccountRepository();
    }

    private static final String CPF = 'CPF';
    private static final String CNPJ = 'CNPJ';
    private static final String INVALID_NUMBER_ERROR = 'Número do cliente é inválido';

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

    public void validateAccountNumber( List<Account> accounts ){

        List<Account> filteredAccounts = filter.byCpfOrCnpjType( accounts );

        if( filteredAccounts == null || accounts.isEmpty() ) return;

        for( Account account : filteredAccounts ){

            if( account.Type == CPF && !Utils.isValidDocumentNumber( account.AccountNumber, 11 ) ){

                account.addError( INVALID_NUMBER_ERROR );
                continue;
            }

            if( account.Type == CNPJ && !Utils.isValidDocumentNumber( account.AccountNumber, 14 ) ){

                account.addError( INVALID_NUMBER_ERROR );
                continue;
            }

        }

    }

}
