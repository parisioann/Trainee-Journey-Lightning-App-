
public inherited sharing class bg_JourneyScheduledJobs implements Schedulable {
    private Batch_Size__mdt batchSize;
    @testVisible private Integer recordsToProcess;

    @testVisible private Integer getNumberOfRecordsToProcess()
    {
        if (recordsToProcess == null)
        {
            batchSize = Batch_Size__mdt.getInstance('Batch_Size');
            recordsToProcess = (Integer) batchSize.Number_of_Records__c;
        }
        if (recordsToProcess == null)
        {
            recordsToProcess = 2000;
        }
        return recordsToProcess;     
    }

    public void execute(SchedulableContext ctx)
    {
        bg_JourneyTasksProgressSendEmail journeyTasksProgressEmail = new bg_JourneyTasksProgressSendEmail();
        Database.executeBatch(journeyTasksProgressEmail, getNumberOfRecordsToProcess());
    }

}
