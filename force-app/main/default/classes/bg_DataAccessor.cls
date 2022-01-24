public inherited sharing class bg_DataAccessor {
    
    public static List<Template__c> getTemplateTasksInfo(List<Id> templateIds)
    {
        List<Template__c> templateInfo = [SELECT Id, Name, (SELECT Id, Name, TaskRequirements__c, RelativeDaystoComplete__c FROM Template_Tasks__r) 
                                FROM Template__c WHERE Id IN :templateIds WITH SECURITY_ENFORCED];
        
        return templateInfo;
    }

    public static List<JourneyTask__c> getJourneyTasks(Id journeyId)
    {
        return [SELECT Id, Name, CompletionStatus__c, EstimatedCompletionDate__c, RelativeDaystoComplete__c, TaskRequirements__c
                FROM JourneyTask__c 
                WHERE Journey__c = :journeyId WITH SECURITY_ENFORCED];           
    }

    public static Database.QueryLocator getOverdueInProgressJourneyTasks()
    {
        return Database.getQueryLocator([SELECT Name, CompletionStatus__c, Journey__r.CandidateName__c, EstimatedCompletionDate__c 
                                        FROM JourneyTask__c 
                                        WHERE CompletionStatus__c = 'Overdue' 
                                        OR (CompletionStatus__c = 'In Progress' AND EstimatedCompletionDate__c <= NEXT_N_DAYS:7) 
                                        ORDER BY Journey__r.CandidateName__c, EstimatedCompletionDate__c ASC
                                        NULLS LAST]);
    }
    
}
