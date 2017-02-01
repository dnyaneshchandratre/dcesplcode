// VERY GOOD !! :)
// BUT YOU WILL BE EXPLAINING THIS TO ME

public with sharing class ScheduleRecordCreation implements Schedulable {

    Integer intervalMinutes;
    public ScheduleRecordCreation(Integer intervalMinutes) {
        this.intervalMinutes = intervalMinutes;
    }

    public void execute(SchedulableContext sc) {
        // Re-schedule ourself to run again in "intervalMinutes" time [Done]
        // Database.executeBatch(new JsonToRecordCreator());
        DateTime now  = DateTime.now();
        DateTime nextRunTime = now.addMinutes(intervalMinutes);

        // INTENDED FOR YOU
        String cronString = ' ' + nextRunTime.second()
                          + ' ' + nextRunTime.minute()
                          + ' ' + nextRunTime.hour()
                          + ' ' + nextRunTime.day()
                          + ' ' + nextRunTime.month()
                          + ' ? ' + nextRunTime.year();
        System.schedule(
            ScheduleRecordCreation.class.getName() + '-' + now.format(),
            cronString,
            new ScheduleRecordCreation(intervalMinutes)
        );
        // Abort the current job
        Id jobId = sc.getTriggerId();
        System.abortJob(jobId);
        // Launch a batch job or call a future method to do the actual work
    }

}