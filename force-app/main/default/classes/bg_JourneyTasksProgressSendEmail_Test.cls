@isTest
private class bg_JourneyTasksProgressSendEmail_Test {
   
    @isTest static void test_withTasks()
    {
        Integer batchSize = 2000;
        Journey__c journey = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        journey.OnboardingStartDate__c = date.today().addDays(-10);
        insert journey;
        List<JourneyTask__c> journeyTasksOverdue = bg_JourneyService_DataFactory.createJourneyTasks(batchSize/2, journey, 7);
        insert journeyTasksOverdue;
        List<JourneyTask__c> journeyTasksInProgress = bg_JourneyService_DataFactory.createJourneyTasks(batchSize/2, journey, 15);
        insert journeyTasksInProgress;
        Integer numOfErrorsAssert = 0;

        Test.startTest();
        bg_JourneyTasksProgressSendEmail sendEmail = new bg_JourneyTasksProgressSendEmail();
        Id jobId = Database.executeBatch(sendEmail, batchSize);
        Test.stopTest();
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id =:jobId];

        List<JourneyTask__c> scope = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                        FROM JourneyTask__c 
                                        WHERE CompletionStatus__c = 'Overdue' 
                                        OR (CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7) 
                                        ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC];
        
        System.assertEquals(batchSize, scope.size(), 'Number of Journey Tasks records returned, should be ' + batchSize);
        System.assertEquals(batchSize/2, [SELECT count() FROM JourneyTask__c WHERE CompletionStatus__c = 'Overdue'], 
                            'Number of Overdue Journey Tasks records returned, should be ' + batchSize/2);
        System.assertEquals(batchSize/2, [SELECT count() FROM JourneyTask__c WHERE CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7], 
                            'Number of In Progress Journey Tasks records returned, should be ' + batchSize/2);
        System.assertEquals('Completed', a.Status, 'Job has failed to complete.');
        System.assertEquals(numOfErrorsAssert, a.NumberOfErrors, 'There was(were) ' + a.NumberOfErrors + 'error(s) when tried to process this job.');    
    }
    
    @isTest static void test_withoutTasks()
    {
        Integer batchSize = 2000;
        Test.startTest();
        bg_JourneyTasksProgressSendEmail sendEmail = new bg_JourneyTasksProgressSendEmail();
        Id jobId = Database.executeBatch(sendEmail, batchSize);
        Test.stopTest();
        
        AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                            FROM AsyncApexJob WHERE Id =:jobId];
        
        List<JourneyTask__c> scope = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                        FROM JourneyTask__c 
                                        WHERE CompletionStatus__c = 'Overdue' 
                                        OR (CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7) 
                                        ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC];
        
        System.assertEquals(true, scope.isEmpty(), 'Tasks List should be empty.');
        System.assertEquals('Completed', a.Status, 'Job has failed to be completed, it should have gone through with 0 records to process.');
    }
}