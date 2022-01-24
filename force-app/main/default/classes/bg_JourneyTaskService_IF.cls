public interface bg_JourneyTaskService_IF {
    //Handles negative values when Days to Complete fall below zero
    void handleNegativeCompletionDays(List<JourneyTask__c> oldJourneyTasksValues, List<JourneyTask__c> updatedJourneyTasksValues);
}
