<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Follow_up_Notification</fullName>
        <description>Follow up Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>dkchandratre@gmail.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>dnyanesh.chandratre@eternussolutions.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Follow_Up_on_Lead</template>
    </alerts>
    <fieldUpdates>
        <fullName>Call_on_Landline</fullName>
        <description>Call the lead on Landline.</description>
        <field>RecordTypeId</field>
        <lookupValue>Call_on_Landline</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Call on Landline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Do_Not_Call</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Do_Not_Call</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RT Do Not Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Landline</fullName>
        <description>Call the lead on landline.</description>
        <field>RecordTypeId</field>
        <lookupValue>Call_on_Landline</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RT Landline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_Mobile</fullName>
        <description>Call the lead on mobile.</description>
        <field>RecordTypeId</field>
        <lookupValue>Call_on_Mobile</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RT Mobile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RT_No_Number</fullName>
        <description>The lead has provided no number.</description>
        <field>RecordTypeId</field>
        <lookupValue>No_Number</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>RT No Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Call on Landline</fullName>
        <actions>
            <name>Call_on_Landline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the record type to Landline.</description>
        <formula>AND( DoNotCall == FALSE, ISBLANK( MobilePhone ) , NOT(ISBLANK( Phone )) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Call on Mobile</fullName>
        <actions>
            <name>RT_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead will fall under this record type if only mobile number is provided.</description>
        <formula>AND(
    DoNotCall == FALSE,
    NOT(
        ISBLANK( MobilePhone )
   )
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Do Not Call</fullName>
        <actions>
            <name>RT_Do_Not_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead will fall under this record type if DNC check-box is true.</description>
        <formula>DoNotCall == TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Follow Up on Lead</fullName>
        <actions>
            <name>Follow_up_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Workflow to remind the owner about follow-up of the lead.</description>
        <formula>Follow_up__c &lt; Today()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>No Number</fullName>
        <actions>
            <name>RT_No_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead will fall under this record type if no number is provided.</description>
        <formula>AND( DoNotCall == FALSE, ISBLANK( Phone ) ,ISBLANK( MobilePhone ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
