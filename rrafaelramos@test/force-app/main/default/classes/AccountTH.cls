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

        this.service.validateAccountNumber( this.newAccounts );

    }

    override
    public void beforeUpdate() {

        this.service.validateAccountNumber( this.newAccounts );

    }

}
