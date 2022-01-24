@isTest
private class bg_JourneyController_Test {

    @isTest static void test_getJourneyTasks_WithTasks()
    {
        Integer numOfJourneyTasks = 4;
        Journey__c singleJourney = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert singleJourney;
        List<JourneyTask__c> journeyTasks = bg_JourneyService_DataFactory.createJourneyTasks(4, singleJourney, 5);
        insert journeyTasks;

        Test.startTest();
        List<JourneyTask__c> testJourneyTaskList = bg_JourneyController.getJourneyTasks(singleJourney.Id);
        Test.stopTest();

        System.assertEquals(numOfJourneyTasks, testJourneyTaskList.size(), 'Number of Journey Tasks returned does not match this Journey\'s Tasks.');   
    }

    @isTest static void test_getJourneyTasks_WithoutTasks()
    {
        Integer numOfJourneyTasks = 0;
        Journey__c singleJourney = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert singleJourney;

        Test.startTest();
        List<JourneyTask__c> testJourneyTaskList = bg_JourneyController.getJourneyTasks(singleJourney.Id);
        Test.stopTest();

        System.assertEquals(numOfJourneyTasks, testJourneyTaskList.size(), 'Number of Journey Tasks returned should be zero.');   
    }

    @isTest static void test_relativeDaysToCompleteMassIncrementBySameAmount_WithTasks()
    {
        Journey__c singleJourney = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert singleJourney;
        List<JourneyTask__c> journeyTasks = bg_JourneyService_DataFactory.createJourneyTasks(4, singleJourney, 5);
        insert journeyTasks;
        Integer expectedNumOfDaysToComplete = 15;

        Test.startTest();
        List<JourneyTask__c> updateTasks = bg_JourneyController.relativeDaysToCompleteMassIncrementBySameAmount(singleJourney.Id, 10);
        Test.stopTest();

        List<JourneyTask__c> getUpdatedTasks = [SELECT Name, RelativeDaystoComplete__c 
                                            FROM JourneyTask__c WHERE Journey__c = :singleJourney.Id ORDER BY Name];

        for (JourneyTask__c task : getUpdatedTasks)
        {
            System.assertEquals(expectedNumOfDaysToComplete, task.RelativeDaystoComplete__c, 
                            'Mass update for Relative Days to Complete has not been successful in the following task: ' +  task);
        }
        System.assertEquals(updateTasks.size(), getUpdatedTasks.size(), 
                            'Number of updated Journey Tasks should be equal to ' + journeyTasks.size());
    }

    @isTest static void test_relativeDaysToCompleteMassIncrementBySameAmount_WithoutTasks()
    {
        Journey__c singleJourney = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert singleJourney;
        Integer numOfJourneyTasks = 0;

        Test.startTest();
        List<JourneyTask__c> updateTasks = bg_JourneyController.relativeDaysToCompleteMassIncrementBySameAmount(singleJourney.Id, 10);
        Test.stopTest();

        System.assertEquals(numOfJourneyTasks, updateTasks.size(), 'There should be no updated Journey Tasks returned.');
    }

}