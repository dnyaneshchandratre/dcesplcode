<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Alert_for_New_Project_Assignment</fullName>
        <description>Alert for New Project Assignment</description>
        <protected>false</protected>
        <recipients>
            <recipient>dnyanesh.chandratre@eternussolutions.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Project_Assignment</template>
    </alerts>
    <alerts>
        <fullName>End_Date_in_5_Days</fullName>
        <description>End Date in 5 Days</description>
        <protected>false</protected>
        <recipients>
            <recipient>dnyanesh.chandratre@eternussolutions.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Reminder_of_End_Date</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_in_Status_of_Project</fullName>
        <description>Status is changed to closed on the end date of the project.</description>
        <field>Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Change in Status of Project</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Deadline Reminder</fullName>
        <active>true</active>
        <description>Mail to the project manager 5 days before the project end date.</description>
        <formula>(End_Date__c -  TODAY()) &gt;= 5</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>End_Date_in_5_Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Project_Detail__c.End_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>New Project Assignment</fullName>
        <actions>
            <name>Alert_for_New_Project_Assignment</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Project_Assignment</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>A calendar task is created and manager is notified by the mail that he has been assigned a new task.</description>
        <formula>DATEVALUE( CreatedDate )== TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Project Details Workflow</fullName>
        <actions>
            <name>Alert_for_New_Project_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Defines all the rules for Project Detail Object.</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Change_in_Status_of_Project</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Project_Detail__c.End_Date__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>End_Date_in_5_Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Project_Detail__c.End_Date__c</offsetFromField>
            <timeLength>-5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Project Status</fullName>
        <actions>
            <name>Change_in_Status_of_Project</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Changes project status to closed if today is end date of the project.</description>
        <formula>End_Date__c &gt; TODAY()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <tasks>
        <fullName>Project_Assignment</fullName>
        <assignedTo>dnyanesh.chandratre@eternussolutions.com</assignedTo>
        <assignedToType>user</assignedToType>
        <description>A new project is assigned to the manager.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Project_Detail__c.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Project Assignment</subject>
    </tasks>
</Workflow>
