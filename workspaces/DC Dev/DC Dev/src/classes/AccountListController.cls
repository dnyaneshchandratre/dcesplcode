/**
 *  Title   : Controller class for AccountList.page and RelatedContacts.page
 *  Class   : AccountListController
 *  Author  : Dnyanesh Chandratre
 *  Created On: 7/22/2015
 */

public with sharing class AccountListController {

    public Boolean searchFlag = false;
    public List<Account> accountList;
    public Boolean alphaFlag = false;
    public List<Contact> relatedContactList;

    public Boolean isRendered                               {get; set;}
    public String searchKey                                 {get; set;}
    public Id AccountId                                     {get; set;}
    public String AccountName                               {get; set;}
    public List<String> alphabetList                        {get; set;}
    public String selectedAlphabet                          {get; set;}
    public List<SelectedContact> selectedContactsList       {get; set;}
    public Contact AssociatedContact                        {get; set;}

    // [DONE]
    public AccountListController() {
        alphabetList = new List<String> {
            'A',
            'B',
            'C',
            'D',
            'E',
            'F',
            'G',
            'H',
            'I',
            'J',
            'K',
            'L',
            'M',
            'N',
            'O',
            'P',
            'Q',
            'R',
            'S',
            'T',
            'U',
            'V',
            'W',
            'X',
            'Y',
            'Z'
        };

        isRendered = false;
        searchKey = '';
    }

    // [DONE]
    public List<Account> getAccountList() {
        if(searchFlag == false) {

            AccountList = [
                SELECT Id,
                       Name,
                       Email_Address__c,
                       Phone,
                       Website
                  FROM Account
              ORDER BY Name
                 LIMIT 1000];

        } else {

            String searchKeyWithWildCardCharacters = '%' + searchKey.trim() + '%';
            AccountList = [
                SELECT Id,
                       Name,
                       Email_Address__c,
                       Phone,
                       Website
                  FROM Account
                 WHERE Name LIKE :searchKeyWithWildCardCharacters
              ORDER BY Name
                 LIMIT 1000
            ];
        }

        return AccountList;
    }

    // [DONE]
    public void searchAccounts() {

        if(searchKey.length() < 3) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.FATAL,
                                                       System.Label.Search_Key_Error_Message));
            searchFlag = false;
        } else {
            searchFlag = true;
            getAccountList();
        }

    }

    // [DONE]
    public PageReference redirectToContacts() {

        AccountId = ApexPages.currentPage().getParameters().get('aid');
        AccountName = ApexPages.currentPage().getParameters().get('an');
        PageReference pageRef = Page.RelatedContacts;

        System.debug('/*/*/*/*/*/*/*/*\n\n\n' + ApexPages.currentPage().getParameters().get('aid'));
        System.debug('/*/*/*/*/*/*/*/*\n\n\n' + ApexPages.currentPage().getParameters().get('an'));

        if(AccountId == NULL || AccountName == NULL) {
            return NULL;
        }

        pageRef.getParameters().put('aid', AccountId);
        pageRef.getParameters().put('an', AccountName);

        pageRef.setRedirect(true);
        return pageRef;

    }

    // [DONE]
    public void getSelectedContactsList() {

        selectedContactsList = new List<SelectedContact>();
        AccountId = ApexPages.currentPage().getParameters().get('aid');
        AccountName = ApexPages.currentPage().getParameters().get('an');
        System.debug('/*/*/*/*/*/*/*/*\n\n\n' + AccountId);
        System.debug('/*/*/*/*/*/*/*/*\n\n\n' + AccountName);

        if(alphaFlag == false) {

            relatedContactList = [
                SELECT Id,
                       Name,
                       Phone,
                       MobilePhone
                  FROM Contact
                 WHERE AccountId =: AccountId
            ];

        } else {

            System.debug('************ \n AlphaFlag = ' + alphaFlag);
            System.debug('************ \n Alphabet = ' + selectedAlphabet);

            String alphabetLike = selectedAlphabet + '%';
            relatedContactList = [
                SELECT Id,
                       Name,
                       Phone,
                       MobilePhone
                  FROM Contact
                 WHERE AccountId = :AccountId
                   AND Name LIKE :alphabetLike
            ];
        }

        if(!relatedContactList.isEmpty()) {

            for(Contact contactIterator : relatedContactList) {
                selectedContactsList.add(new SelectedContact(contactIterator));
            }
        }

    }

    // [DONE]
    public PageReference returnToAccount() {
        return Page.AccountList;
    }

    // [DONE]
    public void clearList() {
        searchKey = '';
        searchFlag = false;
    }

    // [DONE]
    public void searchByAlphabet() {

        selectedAlphabet = ApexPages.currentPage().getParameters().get('selectedAlphabet');
        System.debug('************ \n Alphabet = ' + selectedAlphabet);
        alphaFlag = true;
        SelectedContactsList = new List<SelectedContact>();
        getSelectedContactsList();

    }

    // [DONE]
    @RemoteAction
    public static Boolean deleteRelatedContact(Id contactId) {
        Contact conInstance = new Contact(Id = contactId);

        try {

            delete conInstance;
            return true;

        } catch(DMLException exceptionInstance) {

            ApexPages.addMessage( new ApexPages.Message(
                ApexPages.Severity.FATAL,
                exceptionInstance.getMessage()
            ));
            return false;

        }
    }

    // [DONE]
    public void deleteMultipleContacts() {
        List<Contact> contactList = new List<Contact>(); 

        try {
                System.debug('******** IN DELETE TRY');
                for(SelectedContact selectedContactIterator : selectedContactsList) {
                    System.debug('******** IN DELETE FOR \n\n' + selectedContactIterator);
                    if(true == selectedContactIterator.isSelected) {
                        System.debug('******** IN DELETE FOR -> IF\n\n' + selectedContactIterator);
                        contactList.add(selectedContactIterator.contactInstance);
                    }
                }
            delete contactList;

        } catch(DMLException exceptionInstance) {

            ApexPages.addMessage( new apexPages.Message(
                ApexPages.Severity.FATAL,
                exceptionInstance.getMessage()
            ));

        }
        
    }

    // [DONE]
    public void renderAddContactPanel() {
        AssociatedContact = new Contact();
        isRendered = true;
        AssociatedContact.AccountId = AccountId;
    }

    // [DONE]
    public void saveContact() {
        System.debug('************ \n Contact BEFORE = ' + AssociatedContact);
        insert AssociatedContact;
        System.debug('************ \n Contact AFTER = ' + AssociatedContact);
        // AssociatedContact.clear();
        selectedContactsList.clear();
        getSelectedContactsList();
        isRendered = false;
    }

    // [DONE]
     public class SelectedContact {

         public Boolean isSelected          {get; set;}
         public Contact contactInstance     {get; set;}

         public SelectedContact(Contact contactInstance) {
             isSelected = false;
             this.contactInstance = contactInstance;
         }
     }
}