public inherited sharing class bg_JourneyController {
    @AuraEnabled(cacheable=true)
    public static List<JourneyTask__c> getJourneyTasks(Id journeyId)
    {
       return bg_DataAccessor.getJourneyTasks(journeyId);
    }

    @AuraEnabled
    public static List<JourneyTask__c> relativeDaysToCompleteMassIncrementBySameAmount(Id journeyId, Integer daysToComplete)
    {
        List<JourneyTask__c> tasksToUpdate = bg_DataAccessor.getJourneyTasks(journeyId);
        
        for (JourneyTask__c task : tasksToUpdate)
        {
            task.RelativeDaystoComplete__c += daysToComplete;
        }
        update tasksToUpdate;
        return tasksToUpdate;
    }
    
}
