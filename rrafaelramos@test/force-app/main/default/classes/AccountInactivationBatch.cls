/**
 * @author rrafaelramos
 */
global class AccountInactivationBatch implements Database.Batchable<SObject> {

    AccountService service;
    AccountEnricher enricher;
    AccountRepository repository;

    public AccountInactivationBatch( ){
        this.service = new AccountService();
        this.enricher = new AccountEnricher();
        this.repository = new AccountRepository();
    }

    public Database.QueryLocator start( Database.BatchableContext BC ){

        return repository.findNotInactiveAccounts( );
    }

    public void execute( Database.BatchableContext BC, List<sObject> scope ){

        if( scope == null || scope.isEmpty() ) return;

        List<Account> accounts = (List<Account>) scope;

        accounts = service.getInactiveAccounts( accounts );

        accounts = enricher.withInactiveField( accounts, true );

        update accounts;
    }

    public void finish( Database.BatchableContext BC ){

    }

}
