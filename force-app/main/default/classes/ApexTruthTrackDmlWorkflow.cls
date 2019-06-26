global with sharing class ApexTruthTrackDmlWorkflow
        extends AbstractSobjectWorkflow {

    global override void executeAfter() {
        /* do nothing */
    }

    global override void executeBefore() {
        for (ApexTruth__c eachRecord : (List<ApexTruth__c>)this.records) {
            eachRecord.NumberOfDmlOperations__c++;
        }
    }

    /**
     * Any time there's a DML operation we should be tracking that an operation
     * occurred.
     */
    global override Boolean qualify(Sobject newRecord, Sobject oldRecord) {
        return this.context.isInsert || this.context.isUpdate;
    }
}