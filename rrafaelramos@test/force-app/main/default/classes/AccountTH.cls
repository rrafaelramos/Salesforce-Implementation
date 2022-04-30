/**
 * @author rrafaelramos
 */
public class AccountTH extends TriggerHandler {

    List<Account> newAccounts;

    Map<Id, Account> oldAccounts;

    AccountEnricher enricher;

    AccountService service;

    public AccountTH() {

        this((List<Account>) Trigger.new, (Map<Id, Account>) Trigger.oldMap);

        this.enricher = new AccountEnricher();

        this.service = new AccountService();

    }

    public AccountTH(List<Account> newAccounts, Map<Id, Account> oldAccounts) {
        
        this.newAccounts = newAccounts;
        
        this.oldAccounts = oldAccounts;

    }

    override
    public void beforeInsert() {

        this.validateAccount( );
    }

    override
    public void beforeUpdate() {

        this.validateAccount( );
    }

    override
    public void afterInsert() {

        this.verifyAndCreateRelatedEntitiesForAccount( );
    }

    private void validateAccount( ){

        service.validateAccountNumber( this.newAccounts );
    }

    private void verifyAndCreateRelatedEntitiesForAccount( ){

        service.verifyAndCreateOpportunityForPartnerAccount( this.newAccounts );
        service.verifyAndCreateTaskForFinalCustomer( this.newAccounts );
    }

}
