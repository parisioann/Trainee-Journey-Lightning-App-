@isTest
private class bg_JourneyScheduledJobs_Test {

    @isTest static void test_scheduledJobsEnqueued()
    {
        String cronExp = '0 0 0 L * ? *';
        Integer jobTriggeredTimes = 0;
        
        Test.startTest();
        bg_JourneyScheduledJobs scheduledJobsClass = new bg_JourneyScheduledJobs();
        String jobId = System.schedule('ScheduledApexTest', cronExp, scheduledJobsClass);
        Test.stopTest();
        AsyncApexJob a = [SELECT Id, Status, ApexClassID 
                            FROM AsyncApexJob 
                            WHERE ApexClass.Name = 'bg_JourneyScheduledJobs'];
        CronTrigger ct = [SELECT Id, State, CronExpression, TimesTriggered, NextFireTime
                            FROM CronTrigger WHERE id = :jobId];

        System.assertEquals('Queued', a.Status, 'Job has not been added to the Queue to run in the scheduled date/time.');
        System.assertEquals(jobTriggeredTimes, ct.TimesTriggered, 'Job has been triggered 0 times up to this moment, as scheduled time is in the future.');
        System.assertEquals(cronExp, ct.CronExpression, 'Scheduled date should be ' + cronExp);
        System.assertEquals('WAITING', ct.State, 'State should be \'Waiting\' as scheduled time is in the future.');
    }

    @isTest static void test_customMetadataTypeFieldValue()
    {
        bg_JourneyScheduledJobs scheduledJobsClass = new bg_JourneyScheduledJobs();
        scheduledJobsClass.recordsToProcess = 2000;

        System.assertEquals(scheduledJobsClass.getNumberOfRecordsToProcess(), scheduledJobsClass.recordsToProcess,
                            'Batch Size should be ' + scheduledJobsClass.recordsToProcess);
    }

}