/**
 * @author rrafaelramos
 */
global class AccountInactivationProcessScheduler implements Schedulable {

    private static final String HOUR_00 = '0 0 0 ? * MON,TUE,WED,THU,FRI *';
    private static final String HOUR_06 = '0 0 6 ? * MON,TUE,WED,THU,FRI *';
    private static final String HOUR_12 = '0 0 12 ? * MON,TUE,WED,THU,FRI *';
    private static final String HOUR_18 = '0 0 18 ? * MON,TUE,WED,THU,FRI *';

    public AccountInactivationProcessScheduler() {}

    public void execute( SchedulableContext sc ) {

        this.executeBatch();
    }

    public static void start ()  {
        System.schedule('AccountInactivationBatch first Job Of the Day', HOUR_00, new AccountInactivationProcessScheduler());
        System.schedule('AccountInactivationBatch Second Job Of the Day', HOUR_06, new AccountInactivationProcessScheduler());
        System.schedule('AccountInactivationBatch Third Job Of the Day', HOUR_12, new AccountInactivationProcessScheduler());
        System.schedule('AccountInactivationBatch fourth Job Of the Day', HOUR_18, new AccountInactivationProcessScheduler());
    }

    private void executeBatch(){

        Database.executeBatch( new AccountInactivationBatch(), 200 );
    }

}
