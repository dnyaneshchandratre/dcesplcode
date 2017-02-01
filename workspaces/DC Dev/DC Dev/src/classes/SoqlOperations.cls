/**
 *  Title       : Class to perform SOQL Operations [Assignment 9]
 *  Class       : SoqlOperations
 *  Author      : Dnyanesh Chandratre
 *  Created On  : 7/12/2015
 */

public class SoqlOperations {

    public void fetchPersonAccount() {

        final String PERSON = 'Person';

        List<Account> accountList= [
            SELECT ID 
              FROM Account 
             WHERE Type__c = :PERSON
        ];

        for(Integer iterator = 0; iterator < accountList.size(); iterator++) {
            System.debug(accountList[iterator]);
        }
        System.debug('*********************************');
        for(Account accountInstance : accountList)
            System.debug(accountInstance);
    }

    public void createOpportunityCollections() {

        final String CLOSED_LIKE = 'Closed%';

        List<Opportunity> opportunityList = [SELECT Id,
                                                    AccountID
                                               FROM Opportunity
                                              WHERE AccountID!=NULL 
                                                AND StageName LIKE :CLOSED_LIKE];
        List<Id> OpportunityIdList= new List<Id>();
        Set<Id> AccountIdSet= new Set<Id>();

        Map<Id,Id> opportunityToAccountMap= new Map<Id,Id>();

        for(Integer iterator = 0;iterator<opportunityList.size();iterator++) {

            OpportunityIdList.add(opportunityList[iterator].ID);
            AccountIdSet.add(opportunityList[iterator].AccountID);
            opportunityToAccountMap.put(
                opportunityList[iterator].ID, 
                opportunityList[iterator].AccountID
            );
        }
        System.debug(OpportunityIdList+'\n'+AccountIdSet+'\n'+opportunityToAccountMap);
    }

    public void updateAccount() {

        final String updatedName = 'Updated via update DML operation';

        List<Account> accountUpdateName = [
            SELECT Name
              FROM Account
             WHERE Name LIKE 'A%'
        ];
        System.debug(accountUpdateName.size());

        for(Account accountIterator : accountUpdateName) {
            accountIterator.Name = updatedName;
        }
        update accountUpdateName;
    }

    public void sortCampaign() {

        List<Campaign> campaignList=[
            SELECT ID,
                   name,
                   BudgetedCost
              FROM Campaign
             WHERE BudgetedCost <> NULL
        ];

        List<WrapperForCampaign> campaignAscendingList = new List<WrapperForCampaign>();
        List<WrapperForCampaign> campaignDescendingList = new List<WrapperForCampaign>();

        // Trying out comparable interface
        WrapperForCampaign wrappedCampaign;
        for(Campaign campaignIterator : campaignList) {
            wrappedCampaign = new WrapperForCampaign(campaignIterator);
            campaignAscendingList.add(wrappedCampaign);
        }

        campaignAscendingList.sort();
        System.debug(campaignAscendingList);
        
        /***Ascending order by Budgeted Cost***/

        /*for(Integer i=0;i<camAscList.size();i++)
            for(Integer j=i+1;j<camAscList.size();j++)
                if(camAscList[i].BudgetedCost > camAscList[j].BudgetedCost)
                {
                    temp=camAscList[i];
                    camAscList[i]=camAscList[j];
                    camAscList[j]=temp;
                }
        System.debug(camAscList);
        /***Descending order by Budgeted Cost***/
        /*for(Integer i=0;i<camDescList.size();i++)
            for(Integer j=i+1;j<camDescList.size();j++)
                if(camDescList[i].BudgetedCost < camDescList[j].BudgetedCost)
                {
                    temp=camDescList[i];
                    camDescList[i]=camDescList[j];
                    camDescList[j]=temp;
                }
        System.debug(camDescList);*/
    }

    public void fetchModifiedContacts() {

        List<Contact> contactList=[
            SELECT ID,
                   name
              FROM Contact
             WHERE LastModifiedDate = TODAY
        ];

        System.debug('\n'+contactList);
    }

    public void mapAccountToOpportunity() {

        List<Account> accountList = [SELECT Name,
                                            Id,
                                            (SELECT Id,
                                                    Name
                                               FROM Opportunities)
                                       FROM Account a];

        Map<Id, List<Opportunity>> mapAccount = new Map<Id, List<Opportunity>>();

        for(Account accountIterator : accountList) {
            mapAccount.put(accountIterator.Id, accountIterator.Opportunities);
        }

        for(Id accountId : mapAccount.keySet()) {
            System.debug(mapAccount.get(accountId));
        }
    }

    public class WrapperForCampaign implements Comparable{

        Campaign campaignInstance;

        public WrapperForCampaign(Campaign campaignInstance) {
            this.campaignInstance = campaignInstance;
        }

        public Integer compareTo(Object objectInstance) {

            WrapperForCampaign wrapperInstance = (WrapperForCampaign)objectInstance;

            if(this.campaignInstance.budgetedCost > wrapperInstance.campaignInstance.budgetedCost) {
                return 1;
            }

            if(this.campaignInstance.budgetedCost < wrapperInstance.campaignInstance.budgetedCost) {
                return -1;
            }

            else {
                return 0;
            }

        }
    }
}