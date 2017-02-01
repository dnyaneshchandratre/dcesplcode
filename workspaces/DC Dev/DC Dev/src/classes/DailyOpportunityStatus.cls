public with sharing class DailyOpportunityStatus implements Database.Batchable<sObject>, Database.Stateful, Schedulable {

    public final static String query = 'SELECT Name,'
                                     + '       Amount,' 
                                     + '       AccountId,' 
                                     + '       Account.Email_Address__c'
                                     + '  FROM Opportunity'
                                     + ' WHERE Account.Email_Address__c <> NULL' 
                                     + '   AND StageName = \'Closed Won\''
                                     + '   AND CloseDate = TODAY';

    public final static String REPLY_TO = 'dnyanesh.chandratre@eternussolutions.com';
    public final static String SENDER_DISPLAY_NAME = 'Eternus Solutions Org.';
    public final static String SUBJECT = 'Daily Opportunity Status';
    public final static String GREETING = 'Hello,';
    public final static String OPENING = 
        'Following is the list of opportunities that were closed won today:';
    public final static String OPOPRTUNITIES = 'Opportunities : <c:Sample_Component />';
    public final static String AMOUNT_MESSAGE = '<br />Total Amount for all opportunities : <br />';

    public Map<String, opportunityDetails> emailToOpportunityMap = 
        new Map<String, opportunityDetails>();

    opportunityDetails opportunityDetailInstance = new opportunityDetails();

    public Database.QueryLocator start(Database.BatchableContext batchableContextInstance) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext batchableContextInstance, List<Opportunity> opportunityList) {

        for(Opportunity opportunityIterator : opportunityList) {

            if(String.isBlank(opportunityIterator.Account.Email_Address__c)) {
                continue;
            }

            if(emailToOpportunityMap.containsKey(opportunityIterator.Account.Email_Address__c)) {

                emailToOpportunityMap.get(opportunityIterator.Account.Email_Address__c)
                                     .opportunityList
                                     .add(opportunityIterator);

                opportunityDetailInstance = emailToOpportunityMap.get(opportunityIterator.Account.Email_Address__c);
                opportunityDetailInstance.aggregatedAmount += opportunityIterator.Amount;
            }

            else {
                opportunityDetailInstance = new opportunityDetails();
                opportunityDetailInstance.opportunityList.add(opportunityIterator);
                opportunityDetailInstance.aggregatedAmount = opportunityIterator.Amount;

                emailToOpportunityMap.put(  opportunityIterator.Account.Email_Address__c
                                          , opportunityDetailInstance);
            }
        }

        System.debug('******** + + Map : \n' + emailToOpportunityMap);
    }

    public void execute(SchedulableContext sc) {}

    public void finish(Database.BatchableContext bc) {

        List<Messaging.SingleEmailMessage> mailsList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        List<String> sendToList = new List<String>();
        sendToList.addAll(emailToOpportunityMap.keySet());

        // sendToList.add([SELECT Id, Email_Address__c FROM Account WHERE Id = '00128000006kbTm' LIMIT 1][0].Email_Address__c);

        

        for(String email : emailToOpportunityMap.keySet()) {

            mail = new Messaging.SingleEmailMessage();

            mail.setReplyTo(REPLY_TO);
            mail.setSenderDisplayName(SENDER_DISPLAY_NAME);
            mail.setSubject(SUBJECT);

            String body = GREETING;
            body += OPENING;
            body += OPOPRTUNITIES + emailToOpportunityMap.get(email).opportunityList;
            body += AMOUNT_MESSAGE;
            body += emailToOpportunityMap.get(email).aggregatedAmount;

            mail.setHtmlBody(body);
            System.debug('********\n\n' + mail.getHtmlBody());
            mailsList.add(mail);

        }

        mail.setToAddresses(sendToList);
        System.debug('/*/*/*/*/*/*/*/*/*/*/* \n\n\n\n' + mail.getToAddresses());
//        try {
            Messaging.sendEmail(mailsList);
   //         System.assert(false, 'FATA YAHA BHI!!!!');

  //      } catch(Exception exceptionInstance) {
    //        System.debug(exceptionInstance.getMessage());
      //  }

    }

    public class opportunityDetails {
        public List<Opportunity> opportunityList;
        public Decimal aggregatedAmount;

        public opportunityDetails() {
            opportunityList = new List<Opportunity>();
            aggregatedAmount = 0;
        }
    }

}