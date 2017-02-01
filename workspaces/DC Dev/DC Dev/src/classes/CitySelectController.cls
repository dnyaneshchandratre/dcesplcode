public with sharing class CitySelectController {

    public String selectedCountry              {get; set;}
    public string selectedCity                 {get; set;}
    public List<SelectOption> countryPickList  {get; set;}
    public List<selectOption> cityPickList     {get; set;}

    public void init() {
        populateCountryPickList();
    }

    public List<SelectOption> populateCountryPickList() {

        countryPickList = new List<SelectOption>();

        countryPickList.add( new SelectOption(
                'NULL',
                '--- Select Country ---'
            ));

        for (Country__c countryInstance : Country__c.getAll().Values()) {

            countryPickList.add( new SelectOption(
                countryInstance.Name,
                countryInstance.Name
            ));
        }

        return countryPickList;
    }

    public void populateCityPickList() {
        cityPickList = new List<SelectOption>();
        for (City__c cityInstance : [
            SELECT Name 
              FROM City__c
             WHERE Country__c = :selectedCountry
        ]) {
            cityPickList.add( new SelectOption(
                cityInstance.Name,
                cityInstance.Name
            ));
        }
    }
}