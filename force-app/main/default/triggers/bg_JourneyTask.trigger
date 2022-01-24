trigger bg_JourneyTask on JourneyTask__c (before update) {

    bg_JourneyTaskService.handleNegativeCompletionDays(Trigger.old, Trigger.new);
}