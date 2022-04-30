/**
 * @author rrafaelramos
 */
public class TaskRepository {
    
    public List<Task> findByIds( Set<String> tasksId ){

        return [ SELECT Id, WhatId, Subject, Status, Priority
                 FROM Task
                 WHERE Id in: tasksId ];

    }

    public Task findById ( String taskId ) {

        List<Task> tasks = findByIds( new Set<String>{ taskId } );

        return tasks != null && !tasks.isEmpty() ? tasks.get(0) : null;
    }

    public Task findOneByAccountId( String accountId ){

        List<Task> tasks = [ SELECT Id, WhatId, Subject, Status, Priority
                 FROM Task
                 WHERE WhatId = :accountId ];

        return tasks != null && !tasks.isEmpty() ? tasks.get(0) : null;
    }

}

