public inherited sharing class bg_JourneyService implements bg_JourneyService_IF{

    public static Map<Id, List<TemplateTask__c>> pairTemplateWithTasks(List<Journey__c> journeys)
    {
        List<Id> storeTemplateIds = new List<Id>();
        
        for (Journey__c journey : journeys)
        {
            storeTemplateIds.add(journey.Template__c);
        }
        
        List<Template__c> templateTaskInfo = bg_DataAccessor.getTemplateTasksInfo(storeTemplateIds);
        Map<Id, List<TemplateTask__c>> templateTasksByTemplateId = new Map<Id, List<TemplateTask__c>>();
        
        for (Template__c temp : templateTaskInfo)
        {
            templateTasksByTemplateId.put(temp.Id, temp.Template_Tasks__r); 
        }
        
        return templateTasksByTemplateId;
    }
     
    public static void copyJourneyTasksFromTemplate(List<Journey__c> journeys)
    {
        Map<Id, List<TemplateTask__c>> templateTasksByTemplateId = pairTemplateWithTasks(journeys);
        List<JourneyTask__c> journeyTasks = new List<JourneyTask__c>();
        
        for (Journey__c journey : journeys)
            {
                if ((journey.Template__c != null) && (templateTasksByTemplateId.containsKey(journey.Template__c)))
                {
                    for (TemplateTask__c task : templateTasksByTemplateId.get(journey.Template__c))
                    {
                        journeyTasks.add(new JourneyTask__c(Name = task.Name, 
                                                RelativeDaystoComplete__c = task.RelativeDaystoComplete__c,
                                                TaskRequirements__c = task.TaskRequirements__c,
                                                Journey__c = journey.Id)); 
                    }  
                }
            }
        insert journeyTasks;
    }  

}