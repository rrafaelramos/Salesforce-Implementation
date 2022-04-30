/**
 * @author rrafaelramos
 */
public class AccountFilter {
    
    private static final String CPF = 'CPF';
    private static final String CNPJ = 'CNPJ';

    public List<Account> byCpfOrCnpjType( List<account> accounts ){

        List<Account> filteredAccounts = new List<Account>();

        for( Account account : accounts ){

            if( account.Type == null || String.isEmpty( account.Type ) ) continue;

            if( account.Type != CPF && account.Type != CNPJ ) continue;

            filteredAccounts.add( account );
        }

        return filteredAccounts;
    }

}
