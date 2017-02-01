public with sharing class StudentExtension {

    public String selectedLang {get;set;}
    public List<selectOption> langList = new List<selectOption>();
    ApexPages.StandardController sc = new ApexPages.StandardController(new Student__c()); 
    Student__c studentInstance;

    public StudentExtension(ApexPages.StandardController sc) {
        studentInstance = (Student__c)sc.getRecord();
    }

    public List<selectOption> getLangList() {
        langList.add(new selectOption('en_US', 'English'));
        langList.add(new selectOption('fr', 'French'));
        langList.add(new selectOption('es', 'Spanish'));
        return langList;
    }

    public void save() {

        ApexPages.addMessage( new apexPages.Message(
            ApexPages.Severity.INFO,
            System.Label.Success_Message
        ));

        insert studentInstance;

        studentInstance.clear();
        studentInstance = null;
        studentInstance = new Student__c();
    }

}