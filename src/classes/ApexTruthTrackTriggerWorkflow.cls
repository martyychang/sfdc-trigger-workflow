global with sharing class ApexTruthTrackTriggerWorkflow
        extends AbstractSobjectWorkflow {

    global override void executeAfter(Sobject record) {
        /* do nothing */
    }

    global override void executeBefore(Sobject record) {
        ApexTruth__c truth = (ApexTruth__c)record;
        truth.NumberOfTriggerTouches__c++;
    }

    /**
     * Any time there's a DML operation we should be tracking that an operation
     * occurred.
     */
    global override Boolean qualify(Sobject newRecord, Sobject oldRecord) {
        return Trigger.isInsert || Trigger.isUpdate;
    }
}