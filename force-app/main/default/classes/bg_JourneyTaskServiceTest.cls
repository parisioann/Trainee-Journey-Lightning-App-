@isTest
private class bg_JourneyTaskServiceTest {
    
    @isTest static void test_handleNegativeCompletionDays_PosValue()
    {
        Journey__c singleJourney = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert singleJourney;
        List<JourneyTask__c> journeyTasks = bg_JourneyService_DataFactory.createJourneyTasks(4, singleJourney, 3);
        insert journeyTasks;
        List<JourneyTask__c> oldJourneyTasksValues = [SELECT Id, Name, RelativeDaystoComplete__c, TaskRequirements__c, Journey__c FROM JourneyTask__c ORDER BY Id];
        for (JourneyTask__c task : journeyTasks)
        {
            task.RelativeDaystoComplete__c+=4;
        }

        Test.startTest();
        Database.SaveResult[] srList = Database.update(journeyTasks, false);
        bg_JourneyTaskService.handleNegativeCompletionDays(oldJourneyTasksValues,journeyTasks);
        for (Database.SaveResult sr : srList)
        {
            for (Database.Error error : sr.getErrors())
            {
                System.assertEquals(null, error.getMessage(), 'There should be no error(s) thrown.');
            }
            System.assertEquals(true, sr.isSuccess(), 'DML update statement should have run successfully.');
        }
        Test.stopTest();
        Integer updatedNumOfDays = 7;
        List<JourneyTask__c> checkJourneyTasksValuesDidNotGetUpdated = [SELECT Id, Name, RelativeDaystoComplete__c, TaskRequirements__c, Journey__c FROM JourneyTask__c ORDER BY Id];

        System.assertEquals(updatedNumOfDays, checkJourneyTasksValuesDidNotGetUpdated[0].RelativeDaystoComplete__c, 'New value in Relative Days to Complete should be equal to ' + updatedNumOfDays + '.');   
    }

    @isTest static void test_handleNegativeCompletionDays_NegValue()
    {
        Journey__c singleJourney = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert singleJourney;
        List<JourneyTask__c> journeyTasks = bg_JourneyService_DataFactory.createJourneyTasks(4, singleJourney, 3);
        insert journeyTasks;
        List<JourneyTask__c> oldJourneyTasksValues = [SELECT Id, Name, RelativeDaystoComplete__c, TaskRequirements__c, Journey__c FROM JourneyTask__c ORDER BY Id];
        for (JourneyTask__c task : journeyTasks)
        {
            task.RelativeDaystoComplete__c -= 4;
        }
        String errorMsg = System.Label.Negative_Value_Days_to_Complete_Error_Msg;
    
        Test.startTest();
        Database.SaveResult[] srList = Database.update(journeyTasks, false);
        bg_JourneyTaskService.handleNegativeCompletionDays(oldJourneyTasksValues,journeyTasks);
        for (Database.SaveResult sr : srList)
        {
            for (Database.Error error : sr.getErrors())
            {
                System.assertEquals(errorMsg, error.getMessage(), 'Error message has not been displayed correctly.');
            }
            System.assertEquals(false, sr.isSuccess(), 'DML update statement should not have run successfully');
        }
        Test.stopTest();  
        
        List<JourneyTask__c> checkJourneyTasksValuesDidNotGetUpdated = [SELECT Id, Name, RelativeDaystoComplete__c, TaskRequirements__c, Journey__c FROM JourneyTask__c ORDER BY Id];

        System.assertEquals(oldJourneyTasksValues[0].RelativeDaystoComplete__c, checkJourneyTasksValuesDidNotGetUpdated[0].RelativeDaystoComplete__c, 'Relative Days to Complete should have not been updated.');   
    }
}
