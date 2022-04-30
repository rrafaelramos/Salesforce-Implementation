/**
 * @author rrafaelramos
 */
 public class AccountRepository extends AbstractRepository {
    
    public List<Account> findByIds( Set<String> accountIds ){

        return [ SELECT Id, AccountNumber, Name, Type, RecordType.Name
                 FROM Account
                 WHERE Id in: accountIds ];

    }

    virtual
    public Account findById ( String accountId ) {

        List<Account> accounts = findByIds( new Set<String>{ accountId } );

        return accounts != null && !accounts.isEmpty() ? accounts.get(0) : null;
    }

    virtual
    public Database.QueryLocator findNotInactiveAccounts( ){

        return Database.getqueryLocator(  [ SELECT id, Inactive__c
                                            FROM Account
                                            WHERE Inactive__c =: false ] );

    }

}
