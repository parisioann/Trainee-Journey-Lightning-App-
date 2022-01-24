public inherited sharing class bg_JourneyTasksProgressEmailHelper {

    public static Integer overdueRecordsProcessed = 0;
    public static Integer recordsDueWithinWeekProcessed = 0;
    public static Integer totalRecordsProcessed = 0;
    public static String htmlBody;

    public static void displayTasksIntoHtmlBody(List<JourneyTask__c> scope)
    {
        for (JourneyTask__c result : scope)
        {
            String candidateName = result.Journey__r.CandidateName__c;
            String taskName = result.Name;
            String status = result.CompletionStatus__c;
            Date dueDate = result.EstimatedCompletionDate__c;
            String formattedDate = (dueDate.day() + '/' + dueDate.month() + '/' + dueDate.year());
                
            if (status == 'Overdue')
            {
                status = '<span style="color:red">' + (String)result.CompletionStatus__c + '</span>';
                overdueRecordsProcessed +=1;
            }
            else
            {
                status = '<span style="color:orange">' + (String)result.CompletionStatus__c + '</span>';
                recordsDueWithinWeekProcessed +=1;
            }  
            htmlBody += '<tr><td>'+ candidateName +'</td><td>'+ taskName +'</td><td>'+ status +'</td><td>'+ formattedDate +'</td></tr>';
        }
        totalRecordsProcessed += scope.size();
    }
}
