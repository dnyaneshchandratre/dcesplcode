/**
 *  Title       : Handler class of createTaskTrigger
 *  Class       : createTaskHandler
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/16/2015
 */

public with sharing class createTaskHandler {

    public static final String MEETING_WITH = 'Meeting with ';

    public static void createTask(list<Account> accountList) {

        list<Task> taskList= new list<Task>();

        for(Account accountIterator : accountList) {
            taskList.add(new Task(Subject = MEETING_WITH + accountIterator.Name));
        }

        insert taskList;

    }
}