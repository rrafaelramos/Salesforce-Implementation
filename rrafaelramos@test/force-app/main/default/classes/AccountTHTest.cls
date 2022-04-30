/**
 * @author rrafaelramos
 */
@isTest
public class AccountTHTest {
    
    public static final String INVALID_ACCOUNT_NUMBER = 'Número do cliente é inválido';
    public static final String NORMAL = 'Normal';
    public static final String NOT_INICIATED = 'Não Iniciada';
    public static final String FINAL_CUSTOMER = 'Consumidor Final';

    @isTest
    public static void givenAAccountWithValidCpfThenAccountIsCreated(  ){

        AccountRepository repository = new AccountRepository();

        Account account = AccountFixtureFactory.newPartnerAccount();
        account.Type = 'CPF';
        account.AccountNumber = '12345678911';

        Test.startTest();
        Account storagedAccount = ( Account ) repository.save( account );
        Test.stopTest();

        System.assertEquals( true, String.isNotEmpty( account.Id ) );
    }

    @isTest
    public static void givenAAccountWithInvalidCpfThenShouldNotBeCreated(  ){

        AccountRepository repository = new AccountRepository();

        Account account = AccountFixtureFactory.newPartnerAccount();
        account.Type = 'CPF';
        account.AccountNumber = '123';

        Boolean hasError = false;

        try {
            Account storagedAccount = ( Account ) repository.save( account );
        } catch( Exception e ){
            if (e.getMessage().contains( INVALID_ACCOUNT_NUMBER ) ) hasError = true;
        }

        System.assert( hasError );
    }

    @isTest
    public static void givenAAccountWithValidCnpjThenAccountIsCreated(  ){

        AccountRepository repository = new AccountRepository();

        Account account = AccountFixtureFactory.newPartnerAccount();
        account.Type = 'CNPJ';
        account.AccountNumber = '12345678911123';

        Test.startTest();
        Account storagedAccount = ( Account ) repository.save( account );
        Test.stopTest();

        System.assertEquals( true, String.isNotEmpty( account.Id ) );
    }

    @isTest
    public static void givenAAccountWithInvalidCnpjThenShouldNotBeCreated(  ){

        AccountRepository repository = new AccountRepository();

        Account account = AccountFixtureFactory.newPartnerAccount();
        account.Type = 'CNPJ';
        account.AccountNumber = '123';

        Boolean hasError = false;

        try {
            Account storagedAccount = ( Account ) repository.save( account );
        } catch( Exception e ){
            if (e.getMessage().contains( INVALID_ACCOUNT_NUMBER ) ) hasError = true;
        }

        System.assert( hasError );
    }

    @isTest
    public static void givenAUpdateAccountWithValidCpfThenAccountIsUpdated(  ){

        AccountRepository repository = new AccountRepository();

        Account account = AccountFixtureFactory.newPartnerAccount();
        account.Type = 'CPF';
        account.AccountNumber = '12345678911';
        
        Account storagedAccount = ( Account ) repository.save( account );

        Test.startTest();
        storagedAccount.AccountNumber = '11987654321';
        Account updatedAccount = ( Account ) repository.save( storagedAccount );
        Test.stopTest();

        System.assertEquals( '11987654321', updatedAccount.AccountNumber );
    }

    @isTest
    public static void givenAPartnerAccountThenAOpportunityIsCreated(  ){

        AccountRepository repository = new AccountRepository();
        OpportunityRepository opportunityRepository = new OpportunityRepository();

        Account account = AccountFixtureFactory.newPartnerAccount();
        account.Type = 'CNPJ';
        account.AccountNumber = '12345678911123';
        
        repository.save( account );
        
        Test.startTest();
        Opportunity opportunity = opportunityRepository.findOneByAccountId( account.Id );
        Test.stopTest();

        Date closeDate = System.now().date().addDays(30);

        System.assert( opportunity != null );
        System.assertEquals( account.Id, opportunity.AccountId );
        System.assertEquals( account.Name + ' – opp Parceiro', opportunity.Name );
        System.assertEquals( closeDate, opportunity.CloseDate );
    }

    @isTest
    public static void givenAFinalCustomerAccountThenATaskIsCreated(  ){

        AccountRepository repository = new AccountRepository();
        TaskRepository taskRepository = new TaskRepository();

        Account account = AccountFixtureFactory.newFinalCustomerAccount();
        account.Type = 'CPF';
        account.AccountNumber = '12345678910';

        repository.save( account );
        
        Test.startTest();
        Task task = taskRepository.findOneByAccountId( account.Id );
        Test.stopTest();

        Date closeDate = System.now().date().addDays(30);

        System.assert( task != null );
        System.assertEquals( account.Id, task.WhatId );
        System.assertEquals( FINAL_CUSTOMER , task.Subject );
        System.assertEquals( NOT_INICIATED , task.Status );
        System.assertEquals( NORMAL , task.Priority );

    }

}
