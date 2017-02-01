public with sharing class ComponentController {

    public List<Object> objectList  {get; set;}
    public Integer recordCount      {get; set;}

    public Integer getRecordCount() {
        recordCount = 0;
        recordCount = objectList.size();
        System.debug('/*/*/*/*/* IN COMPONENT CONTROLLER : ' + recordCount);
        
        return recordcount;
    }
}

/*

    <apex:attribute name="count"
                    description="Displays the total records present on the page."
                    type="Integer"
                    required="true" />

*/