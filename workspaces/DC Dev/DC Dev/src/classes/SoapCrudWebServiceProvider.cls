global with sharing class SoapCrudWebServiceProvider {

// Method to insert new lead
    webservice static SoapCrudWebServiceProvider.ResultantInformation insertLead(
        String pFirstName, String pLastName, String pEmail, String pPhone
    ) {

        ResultantInformation resultInformation = new ResultantInformation();
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
            System.debug('\n\n' + result);

        } catch(DmlException dmlExceptionInstance) {
            exceptionMessage = dmlExceptionInstance.getMessage();
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
    webservice static SoapCrudWebServiceProvider.ResultantInformation deleteLeads(
        String pFirstName,
        String pLastName,
        String pEmail,
        String pPhone
    ) {

        ResultantInformation resultInformation = new ResultantInformation();
        String exceptionMessage;

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
                resultInformation.lead = resultInformation.lead + ',\n' + pFirstname + ' ' + pLastName;
                resultInformation.status = 'Successfully Deleted!';
            }

        }

        return resultInformation;
    }

// Method to update leads
    webservice static SoapCrudWebServiceProvider.ResultantInformation updateLeads(
        String pFirstName,
        String pLastName,
        String pNewEmail,
        String pNewPhone
    ) {

        ResultantInformation resultInformation = new ResultantInformation();
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
                    resultInformation.lead = resultInformation.lead + ',\n' + pFirstname + ' ' + pLastName;
                    resultInformation.status = 'Successfully Updated!';
                }

            }
        }
        return resultInformation;
    }

// Wrapper class for storing end results
    global class ResultantInformation {
        webservice Boolean isSuccess;
        webservice String lead;
        webservice String status;

        public ResultantInformation() {
            isSuccess = false;
            lead = '';
            status = '';
        }
    }

}