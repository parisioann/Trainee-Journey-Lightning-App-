public inherited sharing class bg_JourneyTasksProgressSendEmail implements Database.Batchable<sObject>, Database.Stateful {
  private Integer overdueRecordsProcessed = 0;
  private Integer recordsDueWithinWeekProcessed = 0;
  private Integer totalRecordsProcessed = 0;
  private String htmlBody =
    '<h1 style="font-size: 14px; font-weight: bold; font-family:Calibri; line-height: 18px; color: #333;">Candidate Progress - Daily Notification</h1><br/>' +
    +'<table border="1" style="border-collapse: collapse"><tr><th>Candidate Name</th><th>Task Name</th><th>Status</th><th>Due Date</th></tr>';
  private String managerEmail = 'parisioannou2017@gmail.com';

  public Database.QueryLocator start(Database.BatchableContext bc) {
    return bg_DataAccessor.getOverdueInProgressJourneyTasks();
  }

  public void execute(
    Database.BatchableContext bc,
    List<JourneyTask__c> scope
  ) {
    bg_JourneyTasksProgressEmailHelper.displayTasksIntoHtmlBody(scope);
    htmlBody += bg_JourneyTasksProgressEmailHelper.htmlBody;
    overdueRecordsProcessed += bg_JourneyTasksProgressEmailHelper.overdueRecordsProcessed;
    recordsDueWithinWeekProcessed += bg_JourneyTasksProgressEmailHelper.recordsDueWithinWeekProcessed;
  }

  public void finish(Database.BatchableContext bc) {
    htmlBody +=
      '</table><br>' +
      '<br/><br/> Total Number of Overdue Tasks: ' +
      overdueRecordsProcessed +
      +'<br/> Total Number of Tasks due within the next week: ' +
      recordsDueWithinWeekProcessed;
    Messaging.reserveSingleEmailCapacity(1);
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    String[] toAddresses = new List<String>{ managerEmail };
    mail.setToAddresses(toAddresses);
    mail.setReplyTo('parisioannou2017@gmail.com');
    mail.setSenderDisplayName('MainlyDigital');
    mail.setSubject('Candidate Progress - Daily Notification');
    mail.setHtmlBody(htmlBody);
    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
