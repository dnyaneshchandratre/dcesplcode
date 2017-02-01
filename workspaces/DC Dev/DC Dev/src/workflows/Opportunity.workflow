<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Approval_Request</fullName>
        <description>Approval Request</description>
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
        <template>unfiled$public/New_Approval_Request</template>
    </alerts>
    <alerts>
        <fullName>Big_Deal_Alert_Notification</fullName>
        <description>Big Deal Alert Notification</description>
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
        <template>unfiled$public/Big_Deal_Alert_Mail</template>
    </alerts>
    <rules>
        <fullName>Big Deal Alert</fullName>
        <actions>
            <name>Big_Deal_Alert_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Negotiation/Review</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Amount</field>
            <operation>greaterThan</operation>
            <value>50000</value>
        </criteriaItems>
        <description>Send an email to the opportunity owner indicating a big deal is being created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
