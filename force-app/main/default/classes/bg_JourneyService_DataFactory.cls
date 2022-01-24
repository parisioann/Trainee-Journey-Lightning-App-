@isTest
public class bg_JourneyService_DataFactory {
    
    public static List<Template__c> createTemplates(Integer numTemplates)
    {
        List<Template__c> templates = new List<Template__c>();
        
        for (Integer i = 0; i < numTemplates; i++)
        {
            templates.add(new Template__c (Name='Template ' + i));
        }
        
        return templates;
    }
    
    public static Template__c createSingleTemplate()
    {
        return new Template__c(Name='Single Template');
    }
    
    public static List<TemplateTask__c> createTemplateTasks(Integer numTasks, Template__c template)
    {
        List<TemplateTask__c> templateTasks = new List<TemplateTask__c>();
        
        for (Integer i = 0; i < numTasks; i++)
        {
            templateTasks.add(new TemplateTask__c (Name='Template Task ' + i,
                                                   RelativeDaystoComplete__c = 30,
                                                   Template__c = template.Id));
        }
                           
        return templateTasks;
    }
    
    public static List<Journey__c> createJourneysWithTemplate(Integer numJourney, Template__c template)
    {
        List<Journey__c> journeys = new List<Journey__c>();
        
        for (Integer i = 0; i < numJourney; i++)
        {
            journeys.add(new Journey__c(Name='Journey with Template' + i,
                        				CandidateEmailAddress__c='candemail' + i + '@gmail.com',
                                        CandidateName__c='Cand Name ' + i,
                                        ManagerEmail__c='manageremail' + i + '@gmail.com',
                                        ManagerName__c='Manager Name ' + i,
                                        Template__c=template.Id));
        }
        
        return journeys;
    }    
    
  	public static List<Journey__c> createJourneysWithoutTemplate(Integer numJourney)
    {
        List<Journey__c> journeys = new List<Journey__c>();
        
        for (Integer i = 0; i < numJourney; i++)
        {
            journeys.add(new Journey__c(Name='Journey without Template' + i,
                        				CandidateEmailAddress__c='candemail' + i + '@gmail.com',
                                        CandidateName__c='Cand Name ' + i,
                                        ManagerEmail__c='manageremail' + i + '@gmail.com',
                                        ManagerName__c='Manager Name ' + i));
        }
        
        return journeys;
    } 
    
    public static Journey__c createSingleJourneyWithoutTemplate()
    {
        return new Journey__c(Name='Single Journey',
                        		CandidateEmailAddress__c='candemail@gmail.com',
                                CandidateName__c='Cand Name',
                                ManagerEmail__c='manageremail@gmail.com',
                                ManagerName__c='Manager Name');
    }
    
    public static Journey__c createSingleJourneyWithTemplate(Template__c template)
    {
        return new Journey__c(Name='Single Journey with Template',
                        				CandidateEmailAddress__c='candemail@gmail.com',
                                        CandidateName__c='Cand Name',
                                        ManagerEmail__c='manageremail@gmail.com',
                                        ManagerName__c='Manager Name',
                             			Template__c=template.Id);
    }

    public static List<JourneyTask__c> createJourneyTasks(Integer numTasks, Journey__c journey, Integer daysToComplete)
    {
        List<JourneyTask__c> journeyTasks = new List<JourneyTask__c>();
        for (Integer i = 0; i < numTasks; i++)
        {
            journeyTasks.add(new JourneyTask__c(Name='Journey Task ' + i,
                                                RelativeDaystoComplete__c = daysToComplete,
                                                TaskRequirements__c = '<p>Follow Instructions<p>',
                                                Journey__c = Journey.Id));
        }
        return journeyTasks;
    }
}