public inherited sharing class bg_JourneyTaskService implements bg_JourneyTaskService_IF{

    public static void handleNegativeCompletionDays(List<JourneyTask__c> oldJourneyTasksValues, List<JourneyTask__c> updatedJourneyTasksValues)
    {
        for (Integer i = 0; i < oldJourneyTasksValues.size(); i++)
        {
            if ((oldJourneyTasksValues[i].RelativeDaystoComplete__c + updatedJourneyTasksValues[i].RelativeDaystoComplete__c) <= 0)
            {
                updatedJourneyTasksValues[i].addError(System.Label.Negative_Value_Days_to_Complete_Error_Msg);
            }
        }
    }
}
