<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Employee_Deactivation</fullName>
        <ccEmails>dkchandratre@gmail.com</ccEmails>
        <description>Mail to the manager about employee deactivation.</description>
        <protected>false</protected>
        <recipients>
            <recipient>dnyanesh.chandratre@eternussolutions.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Employee_Deactivation</template>
    </alerts>
    <alerts>
        <fullName>Project_Assignment_Mail</fullName>
        <description>Project Assignment Mail</description>
        <protected>false</protected>
        <recipients>
            <recipient>dnyanesh.chandratre@eternussolutions.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Project_Assignment</template>
    </alerts>
    <fieldUpdates>
        <fullName>Employee_Record_Type_Update</fullName>
        <description>set the record type to Non-Technical when ‘Current Employee’ is false</description>
        <field>RecordTypeId</field>
        <lookupValue>Non_Technical</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Employee Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Non_Technical_Employee_Reset</fullName>
        <description>Reset the record type to technical.</description>
        <field>RecordTypeId</field>
        <lookupValue>Technical</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Non Technical Employee Reset</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>One_to_One_Employee_Field</fullName>
        <description>Updates unique field &quot;Role&quot; which holds the one to one relationship.</description>
        <field>Unique_Role__c</field>
        <formula>Role__r.Name</formula>
        <name>One to One Employee Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Employee Deactivation</fullName>
        <actions>
            <name>Employee_Deactivation</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Employee_4__c.Is_Active__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Mail to manager about deactivation of employee.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Non Technical Employee</fullName>
        <actions>
            <name>Employee_Record_Type_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>set the record type to Non-Technical when ‘Current Employee’ is false</description>
        <formula>Current_Employee__c == FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Non Technical Employee Reset</fullName>
        <actions>
            <name>Non_Technical_Employee_Reset</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>set the record type to Non-Technical when ‘Current Employee’ is false</description>
        <formula>Current_Employee__c == TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>One to One Employee</fullName>
        <actions>
            <name>One_to_One_Employee_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For creating one to one relationship between role and employee object.</description>
        <formula>NOT(ISBLANK( Role__r.Name  ))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
