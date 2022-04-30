/**
 * @author rrafaelramos
 */
public class TaskEnricher {

    public static final String NORMAL = 'Normal';
    public static final String NOT_INICIATED = 'Não Iniciada';
    public static final String FINAL_CUSTOMER = 'Consumidor Final';

    public Task withFinalCustomer( Task task, Account account ){

        task.WhatId = account.Id;
        task.Subject = FINAL_CUSTOMER;
        task.Status = NOT_INICIATED;
        task.Priority = NORMAL;

        return task;
    }

}
