<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NumberOfWorkflowTouches</fullName>
        <description>Increment the Num Workflow Touches counter</description>
        <field>NumberOfWorkflowTouches__c</field>
        <formula>NumberOfWorkflowTouches__c + 1</formula>
        <name>Num Workflow Touches</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Processed</fullName>
        <description>Set Processed to TRUE</description>
        <field>IsProcessed__c</field>
        <literalValue>1</literalValue>
        <name>Processed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Num Workflow Touches</fullName>
        <actions>
            <name>NumberOfWorkflowTouches</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Increment the Num Workflow Touches counter</description>
        <formula>TRUE</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Processed</fullName>
        <actions>
            <name>Processed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>ApexTruth__c.IsProcessed__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Set Processed to TRUE to facilitate rerun detection</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
