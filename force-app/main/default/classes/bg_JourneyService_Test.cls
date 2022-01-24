@isTest
private class bg_JourneyService_Test {

    @isTest static void test_pairTemplateWithTasks_SingleTemplateWithTasks_SingleJourney()
    {
        Template__c createSingleTemplate = bg_JourneyService_DataFactory.createSingleTemplate();
        insert createSingleTemplate;
        List<TemplateTask__c> createTemplateTasks = bg_JourneyService_DataFactory.createTemplateTasks(3, createSingleTemplate);
        insert createTemplateTasks;
        Journey__c createSingleJourney = bg_JourneyService_DataFactory.createSingleJourneyWithTemplate(createSingleTemplate);
        insert createSingleJourney;
        createSingleJourney.Template__c = createSingleTemplate.Id;
        
        List<Journey__c> journeys = [SELECT Id, Name, Template__c FROM Journey__c ORDER BY Template__c];
        List<Template__c> templates = [SELECT Id, Name, (SELECT Id, Name, TaskRequirements__c, RelativeDaystoComplete__c FROM Template_Tasks__r) 
                                FROM Template__c ORDER BY Id];
        Integer templatesSize = 1;
        Integer templateTasksSize = 3;
        Integer journeysSize = 1;
       
        Test.startTest();
        Map<Id, List<TemplateTask__c>> templateTasksByTemplateId = bg_JourneyService.pairTemplateWithTasks(journeys);
        Test.stopTest();
        
        System.assertEquals(templates[0].Template_Tasks__r, templateTasksByTemplateId.get(journeys[0].Template__c), 'Template Tasks have not been assigned to the new Journey.');
    	System.assertEquals(templatesSize, templates.size(), 'Template has not been inserted successfully, no Template returned.');
        System.assertEquals(templateTasksSize, templates[0].Template_Tasks__r.size(), 'Template Tasks have not been inserted correctly into the Template, no Tasks returned for this Template.');
        System.assertEquals(journeysSize, journeys.size(), 'Journey has not been inserted successfully, no Journey found.');
        System.assertEquals(templates[0].Id, journeys[0].Template__c, 'Template has not been assigned correctly to the new Journey.');
        System.assertEquals(templateTasksSize, templates[0].Template_Tasks__r.size(), 'There should be ' + templates[0].Template_Tasks__r.size() + ' Journey Tasks.');
    }
    
    @isTest static void test_pairTemplateWithTasks_WithoutTemplate_SingleJourney()
    {
        Journey__c createJourney = bg_JourneyService_DataFactory.createSingleJourneyWithoutTemplate();
        insert createJourney;
        List<Journey__c> journeys = [SELECT Id, Name, Template__c FROM Journey__c];
       
        Test.startTest();
        Map<Id, List<TemplateTask__c>> templateTasksByTemplateId = bg_JourneyService.pairTemplateWithTasks(journeys);
        Test.stopTest();
        
        System.assertEquals(null, templateTasksByTemplateId.get(journeys[0].Template__c), 'There should be no Template attached to this Journey.');
    }
    
    @isTest static void test_pairTemplateWithTasks_BulkTemplateInsertionWithTasks_SingleJourneyEachTemplate()
    {
        List<Template__c> createTemplateBulk = bg_JourneyService_DataFactory.createTemplates(200);
        insert createTemplateBulk;
        List<TemplateTask__c> templateTasks = new List<TemplateTask__c>();
        List<Journey__c> createJourney = new List<Journey__c>();
        for (Template__c template : createTemplateBulk)
        {
            templateTasks.addAll(bg_JourneyService_DataFactory.createTemplateTasks(10, template));
            createJourney.addAll(bg_JourneyService_DataFactory.createJourneysWithTemplate(1, template));
        }
        
        insert templateTasks;
        insert createJourney;
        Integer templatesSize = 200;
        Integer journeyTasksSize = 10;
        
        List<Journey__c> journeys = [SELECT Id, Name, Template__c FROM Journey__c ORDER BY Template__c];
        List<Template__c> templates = [SELECT Id, Name, (SELECT Id, Name, TaskRequirements__c, RelativeDaystoComplete__c FROM Template_Tasks__r) 
                                FROM Template__c ORDER BY Id];
       
        Test.startTest();
        Map<Id, List<TemplateTask__c>> templateTasksByTemplateId = bg_JourneyService.pairTemplateWithTasks(journeys);
        Test.stopTest();
        
        System.assertEquals(templates[0].Template_Tasks__r, templateTasksByTemplateId.get(journeys[0].Template__c), 'Template Tasks failed to be inserted in the Template and/or Template Task Info do not correspond to the correct Template by ID.');
        System.assertEquals(templatesSize, templates.size(), 'Bulk Template insertion failed, expected number of Template is not equal to expected value.');
        System.assertEquals(journeyTasksSize, templates[0].Template_Tasks__r.size(), 'There should be ' + templates[0].Template_Tasks__r.size() + ' Journey Tasks.');
    }
     
    @isTest static void test_copyJourneyTasksFromTemplate_SingleTemplateWithTasks_SingleJourney()
    {
        Template__c createSingleTemplate = bg_JourneyService_DataFactory.createSingleTemplate();
        insert createSingleTemplate;
        List<TemplateTask__c> createTemplateTasks = bg_JourneyService_DataFactory.createTemplateTasks(3, createSingleTemplate);
        insert createTemplateTasks;
        List<Journey__c> createJourney = bg_JourneyService_DataFactory.createJourneysWithoutTemplate(1);
        insert createJourney;
		createJourney[0].Template__c = createSingleTemplate.Id; 
        Integer journeyTasksSize = 3;   
        
        Test.startTest();
        bg_JourneyService.copyJourneyTasksFromTemplate(createJourney);
        Test.stopTest();
        
        List<Journey__c> journeys = [SELECT Id, Name, Template__c, (SELECT Id, Name, TaskRequirements__c, RelativeDaystoComplete__c FROM Journey_Tasks__r ORDER BY Name)
                                     FROM Journey__c ORDER BY Template__c];
        List<Template__c> templates = [SELECT Id, Name, (SELECT Id, Name, TaskRequirements__c, RelativeDaystoComplete__c FROM Template_Tasks__r) 
                                FROM Template__c ORDER By ID];
        
        System.assertEquals(templates[0].Template_Tasks__r[0].Name, journeys[0].Journey_Tasks__r[0].Name, 'Template Tasks, from chosen Template, have not been copied into the Journey as expected.');
        System.assertEquals(journeyTasksSize, journeys[0].Journey_Tasks__r.size(), 'There should be ' + templates[0].Template_Tasks__r.size() + ' Journey Tasks.');
    }
    
    @isTest static void test_copyJourneyTasksFromTemplate_WithoutTemplate_SingleJourney()
    { 
        List<Journey__c> createJourney = bg_JourneyService_DataFactory.createJourneysWithoutTemplate(1);
        insert createJourney;
       
        Test.startTest();
        bg_JourneyService.copyJourneyTasksFromTemplate(createJourney);
        Test.stopTest();
        
        List<JourneyTask__c> journeyTasks = [SELECT Id, Name FROM JourneyTask__c];
        
        System.assertEquals(true, journeyTasks.isEmpty(), 'Journey Tasks should return empty as there is no Template attached to it.');
    }
    
    @isTest static void test_copyJourneyTasksFromTemplate_BulkTemplateInsertionWithTasks_SingleJourney()
    {
        List<Template__c> createTemplateBulk = bg_JourneyService_DataFactory.createTemplates(200);
        insert createTemplateBulk;
        List<TemplateTask__c> templateTasks = new List<TemplateTask__c>();
        for (Template__c template : createTemplateBulk)
        {
            templateTasks.addAll(bg_JourneyService_DataFactory.createTemplateTasks(10, template));
        }
        insert templateTasks;
        
        List<Journey__c> createJourney = bg_JourneyService_DataFactory.createJourneysWithoutTemplate(1);
        insert createJourney;

        for (Template__c template : createTemplateBulk)
        {
            createJourney[0].Template__c = template.Id;   
        }
        Integer templatesSize = 200;
        Integer journeyTasksSize = 10;
        
        Test.startTest();
        bg_JourneyService.copyJourneyTasksFromTemplate(createJourney);
        Test.stopTest();
        
        List<Journey__c> journeys = [SELECT Id, Name, Template__c, (SELECT Id, Name, TaskRequirements__c, RelativeDaystoComplete__c FROM Journey_Tasks__r ORDER BY Name)
                                     FROM Journey__c ORDER BY Template__c];
        List<Template__c> templates = [SELECT Id, Name, (SELECT Id, Name, TaskRequirements__c, RelativeDaystoComplete__c FROM Template_Tasks__r ORDER BY Name) 
                                FROM Template__c ORDER BY Id];
        
        System.assertEquals(templates[0].Template_Tasks__r[0].Name, journeys[0].Journey_Tasks__r[0].Name, 'Template Tasks have not been copied correctly, as they do not much the returned Journey Tasks.');
        System.assertEquals(templatesSize, templates.size(), 'Bulk Template insertion failed, expected number of Template is not equal to expected value.');
    	System.assertEquals(journeyTasksSize, journeys[0].Journey_Tasks__r.size(), 'There should be ' + templates[0].Template_Tasks__r.size() + ' Journey Tasks.');
    }
    
    @isTest static void test_copyJourneyTasksFromTemplate_SingleTemplate_WithoutTemplateTasks_WithJourney()
    {
        Template__c createSingleTemplate = bg_JourneyService_DataFactory.createSingleTemplate();
        insert createSingleTemplate;
        List<Journey__c> createJourney = bg_JourneyService_DataFactory.createJourneysWithoutTemplate(1);
        insert createJourney;
        createJourney[0].Template__c = createSingleTemplate.Id;
 
        Test.startTest();
        bg_JourneyService.copyJourneyTasksFromTemplate(createJourney);
        Test.stopTest();
        
        List<JourneyTask__c> journeyTasks = [SELECT Id, Name FROM JourneyTask__c];
        
        System.assertEquals(true, journeyTasks.isEmpty(), 'Journey Tasks should return empty as there are no Template Tasks to copy from.');
    }

}