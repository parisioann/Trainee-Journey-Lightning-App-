@isTest
private class bg_JourneyTasksProgressEmailHelper_Test {
    @isTest
    static void displayTasksIntoHtmlBodyTest_WithTasks()
    {
        Integer batchSize = 2000;
        Journey__c journey = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        journey.OnboardingStartDate__c = date.today().addDays(-10);
        insert journey;
        List<JourneyTask__c> journeyTasksOverdue = bg_JourneyService_DataFactory.createJourneyTasks(batchSize/2, journey, 7);
        insert journeyTasksOverdue;
        List<JourneyTask__c> journeyTasksInProgress = bg_JourneyService_DataFactory.createJourneyTasks(batchSize/2, journey, 15);
        insert journeyTasksInProgress;
        List<JourneyTask__c> journeyTasksScope = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'Overdue' 
                                            OR (CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7) 
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];

        List<JourneyTask__c> tasksInProgressDueWithinWeek = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                                            FROM JourneyTask__c 
                                                            WHERE CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7
                                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                                            NULLS LAST];

        List<JourneyTask__c> tasksOverdue = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'Overdue'
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];

        Test.startTest();
        bg_JourneyTasksProgressEmailHelper.displayTasksIntoHtmlBody(journeyTasksScope);
        Test.stopTest();

        System.assertEquals(tasksInProgressDueWithinWeek.size(), bg_JourneyTasksProgressEmailHelper.recordsDueWithinWeekProcessed, 
            'Number of tasks In Progress due within next week, should be equal ' + tasksInProgressDueWithinWeek.size() + '.');
        System.assertEquals(tasksOverdue.size(), bg_JourneyTasksProgressEmailHelper.overdueRecordsProcessed, 
            'Number of Overdue Tasks should be ' + tasksOverdue.size() + '.');
        System.assertEquals(journeyTasksScope.size(), bg_JourneyTasksProgressEmailHelper.totalRecordsProcessed, 
            'Total number of Records Processed shoule be equal ' + journeyTasksScope.size() +'.');
    }

    @isTest
    static void displayTasksIntoHtmlBodyTest_WithoutAnyTasks()
    {
        Journey__c journey = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert journey;

        List<JourneyTask__c> journeyTasksScope = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'Overdue' 
                                            OR (CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7) 
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];

        List<JourneyTask__c> tasksInProgressDueWithinWeek = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];

        List<JourneyTask__c> tasksOverdue = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                            FROM JourneyTask__c 
                            WHERE CompletionStatus__c = 'Overdue'
                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                            NULLS LAST];

        Test.startTest();
        bg_JourneyTasksProgressEmailHelper.displayTasksIntoHtmlBody(journeyTasksScope);
        Test.stopTest();
        
        System.assertEquals(journeyTasksScope.size(), bg_JourneyTasksProgressEmailHelper.totalRecordsProcessed, 
            'Number of Tasks should be zero');
        System.assertEquals(tasksInProgressDueWithinWeek.size(), bg_JourneyTasksProgressEmailHelper.recordsDueWithinWeekProcessed, 
            'Number of Tasks should be zero');
        System.assertEquals(tasksOverdue.size(), bg_JourneyTasksProgressEmailHelper.overdueRecordsProcessed, 
            'Number of Overdue Tasks should be zero');
    }

    @isTest
    static void displayTasksIntoHtmlBodyTest_OnlyOverdue()
    {
        Integer batchSize = 2000;
        Journey__c journey = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        journey.OnboardingStartDate__c = date.today().addDays(-10);
        insert journey;
        List<JourneyTask__c> journeyTasksOverdue = bg_JourneyService_DataFactory.createJourneyTasks(batchSize/2, journey, 7);
        insert journeyTasksOverdue;

        List<JourneyTask__c> journeyTasksScope = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'Overdue' 
                                            OR (CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7) 
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];

        List<JourneyTask__c> tasksOverdue = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'Overdue'
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];
                                            
        List<JourneyTask__c> tasksInProgressDueWithinWeek = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];

        Test.startTest();
        bg_JourneyTasksProgressEmailHelper.displayTasksIntoHtmlBody(journeyTasksScope);
        Test.stopTest();

        System.assertEquals(tasksOverdue.size(), bg_JourneyTasksProgressEmailHelper.overdueRecordsProcessed, 
            'Number of Overdue Tasks should be ' + tasksOverdue.size() + '.');
        System.assertEquals(journeyTasksScope.size(), bg_JourneyTasksProgressEmailHelper.totalRecordsProcessed, 
            'Total number of Records Processed shoule be equal ' + journeyTasksScope.size() +'.');
        System.assertEquals(tasksInProgressDueWithinWeek.size(), bg_JourneyTasksProgressEmailHelper.recordsDueWithinWeekProcessed, 
            'Number of Tasks should be zero');
        }

    @isTest
    static void displayTasksIntoHtmlBodyTest_OnlyDueWithinWeek()
    {
        Integer batchSize = 2000;
        Journey__c journey = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        journey.OnboardingStartDate__c = date.today().addDays(-10);
        insert journey;
        List<JourneyTask__c> journeyTasksInProgress = bg_JourneyService_DataFactory.createJourneyTasks(batchSize/2, journey, 15);
        insert journeyTasksInProgress;

        List<JourneyTask__c> journeyTasksScope = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                            FROM JourneyTask__c 
                                            WHERE CompletionStatus__c = 'Overdue' 
                                            OR (CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7) 
                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                            NULLS LAST];

        List<JourneyTask__c> tasksInProgressDueWithinWeek = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                                            FROM JourneyTask__c 
                                                            WHERE CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7
                                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                                            NULLS LAST];

        List<JourneyTask__c> tasksOverdue = [SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                                            FROM JourneyTask__c 
                                                            WHERE CompletionStatus__c = 'Overdue'
                                                            ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                                            NULLS LAST];

        Test.startTest();
        bg_JourneyTasksProgressEmailHelper.displayTasksIntoHtmlBody(journeyTasksScope);
        Test.stopTest();

        System.assertEquals(tasksInProgressDueWithinWeek.size(), bg_JourneyTasksProgressEmailHelper.recordsDueWithinWeekProcessed, 
            'Number of tasks In Progress due within next week, should be equal ' + tasksInProgressDueWithinWeek.size() + '.');
        System.assertEquals(journeyTasksScope.size(), bg_JourneyTasksProgressEmailHelper.totalRecordsProcessed, 
            'Total number of Records Processed shoule be equal ' + journeyTasksScope.size() +'.');
        System.assertEquals(tasksOverdue.size(), bg_JourneyTasksProgressEmailHelper.overdueRecordsProcessed, 
            'Number of Overdue Tasks should be zero');
    }
}
