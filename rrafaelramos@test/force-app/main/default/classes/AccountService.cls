/**
 * @author rrafaelramos
 */
public class AccountService {

    public AccountFilter filter;
    public AccountEnricher enricher;
    public AccountRepository repository;
    public OpportunityService opportunityService;
    public TaskService taskService;

    public AccountService(){
        this.filter = new AccountFilter();
        this.enricher = new AccountEnricher();
        this.repository = new AccountRepository();
        this.opportunityService = new OpportunityService();
        this.taskService = new TaskService();
    }

    private static final String CPF = 'CPF';
    private static final String CNPJ = 'CNPJ';
    private static final String INVALID_NUMBER_ERROR = 'Número do cliente é inválido';
    private static final String PARTNER = 'Parceiro';
    private static final String FINAL_CUSTOMER = 'Consumidor final';

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

    public List<Account> getAccountByRecordTypeName( List<Account> accounts, String recordTypeName ){

        Set<String> accountsId = new Set<String>();

        for( Account account : accounts ) accountsId.add( account.Id );

        List<Account> accountsWithRecordTypeName = repository.findByIds( accountsId );

        return filter.byRecordTypeName( accounts, recordTypeName );
    }

    public void verifyAndCreateOpportunityForPartnerAccount( List<Account> accounts ){

        List<Account> partnerAccounts = getAccountByRecordTypeName( accounts, PARTNER );

        if( partnerAccounts == null || partnerAccounts.isEmpty() ) return;

        opportunityService.createOpportunityForPartnerAccount( partnerAccounts );
    }

    public void verifyAndCreateTaskForFinalCustomer( List<Account> accounts ){

        List<Account> finalCustomerAccounts = getAccountByRecordTypeName( accounts, FINAL_CUSTOMER );

        if( finalCustomerAccounts == null || finalCustomerAccounts.isEmpty() ) return;

        taskService.createTaskForFinalCustomer( finalCustomerAccounts );
    }

}
