@restResource(urlMapping = '/restwebservice/*')

global with sharing class RestCrudWebServiceProvider{

// Method to insert new lead
    @HttpPost
    global static resultantInformation insertLead(
        String pFirstName, String pLastName, String pEmail, String pPhone
    ) {

        resultantInformation resultInformation = new resultantInformation();
        String exceptionMessage;

        Lead newRecord = new Lead(
            FirstName = pFirstName,
            Company = 'Test Company',
            LastName = pLastName,
            Email = pEmail,
            Phone = pPhone
        );

        Database.SaveResult result;

        try {
                result = Database.insert(newRecord);

            } catch(DmlException exceptionInstance) {
                exceptionMessage = exceptionInstance.getMessage();
            }

        if(result <> NULL && true == result.isSuccess()) {

            resultInformation.isSuccess = result.isSuccess();
            resultInformation.lead = newRecord.Id;
            resultInformation.status = 'Successfully Inserted!';

        } else {
            resultInformation.status = exceptionMessage;
        }
        System.debug(resultInformation);
        return resultInformation;
    }

// Method to delete the leads matching the criteria
    @HttpDelete
    global static resultantInformation deleteLeads() {

        resultantInformation resultInformation = new resultantInformation();
        String exceptionMessage;

        String pFirstName = RestContext.Request.params.get('fn');
        String pLastName = RestContext.Request.params.get('ln');
        String pEmail = RestContext.Request.params.get('em');
        String pPhone = RestContext.Request.params.get('ph');

        List<Lead> recordsToDelete = [
            SELECT Id
              FROM Lead
             WHERE FirstName = :pFirstName
               AND LastName = :pLastName
               AND Email = :pEmail
               AND Phone = :pPhone
        ];

        List<Database.DeleteResult> results = new List<Database.DeleteResult>();

        try {
                results = Database.delete(recordsToDelete);
        } catch(DmlException exceptionInstance) {
            exceptionMessage = exceptionInstance.getMessage();
        }

        if(results.isEmpty() == true) {
            resultInformation.status = exceptionMessage;
            return resultInformation;
        }

        for(Database.DeleteResult resultIterator : results) {

            if(true == resultIterator.isSuccess()) {
                resultInformation.isSuccess = resultIterator.isSuccess();
                resultInformation.lead = pFirstname + ' ' + pLastName;
                resultInformation.status = 'Successfully Deleted!';
            }

        }
        return resultInformation;
    }

// Method to update leads
    @HttpPatch
    global static resultantInformation updateLeads(
        String pFirstName,
        String pLastName,
        String pNewEmail,
        String pNewPhone
    ) {

        resultantInformation resultInformation = new resultantInformation();
        String exceptionMessage;

        List<Lead> recordsToUpdate = [
            SELECT Id
              FROM Lead
             WHERE FirstName = :pFirstName
               AND LastName = :pLastName
        ];

        if(true == recordsToUpdate.isEmpty()) {
            resultInformation.status = 'There was an error in the updation process.';
            return resultInformation;
        }
        else {
            for(Lead leadIterator : recordsToUpdate) {
                leadIterator.Phone = pNewPhone;
                leadIterator.Email = pNewEmail;
            }

            List<Database.SaveResult> results = new List<Database.SaveResult>();

            try {
                results = Database.update(recordsToUpdate);

            } catch(DmlException exceptionInstance) {
                exceptionMessage = exceptionInstance.getMessage();
            }

            for(Database.SaveResult resultIterator : results) {

                if(true == resultIterator.isSuccess()) {
                    resultInformation.isSuccess = resultIterator.isSuccess();
                    resultInformation.lead = pFirstname + ' ' + pLastName;
                    resultInformation.status = 'Successfully Updated!';
                }

            }
        }
        return resultInformation;
    }

// Wrapper class for storing end results
    global class resultantInformation {
        global Boolean isSuccess;
        global String lead;
        global String status;

        public resultantInformation() {
            isSuccess = false;
            lead = '';
            status = '';
        }
    }
}