trigger ApexTruthTrigger on ApexTruth__c (
        before insert, after insert,
        before update, after update,
        before delete, after delete, after undelete) {

    // For readability, get a handle on the TriggerService object
    // for this Sobject type
    TriggerService service = TriggerService.getInstance(
        Schema.sobjectType.ApexTruth__c.getName(),
        TriggerWorkflowContext.getInstance()
    );

    // Process all of the trigger workflows
    service.processActiveWorkflows();
}