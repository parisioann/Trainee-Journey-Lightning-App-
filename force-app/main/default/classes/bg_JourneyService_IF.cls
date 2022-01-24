public interface bg_JourneyService_IF {
    //Map each Template to its Template Tasks, returns information as a pair
    Map<Id, List<TemplateTask__c>> pairTemplateWithTasks(List<Journey__c> journeys); 

    //Populate Journey Tasks from Template, if a Template has been chosen 
    void copyJourneyTasksFromTemplate(List<Journey__c> journeys);
}