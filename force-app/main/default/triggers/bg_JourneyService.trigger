trigger bg_JourneyService on Journey__c (after insert){

	bg_JourneyService.copyJourneyTasksFromTemplate(Trigger.New);
}