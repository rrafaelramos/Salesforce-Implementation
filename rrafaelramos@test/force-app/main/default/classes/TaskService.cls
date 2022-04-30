/**
 * @author rrafaelramos
 */
public class TaskService {

    public TaskEnricher enricher;

    public TaskService( ){
        this.enricher = new TaskEnricher();
    }

    public void createTaskForFinalCustomer( List<Account> accounts ){

        List<Task> tasks = new List<Task>();

        for( Account account : accounts ){

            Task task = new Task();

            task = enricher.withFinalCustomer( task, account );

            tasks.add( task );
        }

        if( tasks != null && !tasks.isEmpty() ) insert tasks;
    }

}
