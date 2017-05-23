@isTest
private class ApexTruthTrackDmlWorkflowTest {

    /**
     * After a record is inserted where nothing special happens other
     * than the Set Num Workflow Touches workflow rule, the key fields
     * on the Apex truth should show the following.
     *
     * - 1 DML operation
     * - 1 workflow touch
     * - 2 trigger touches, with the 2nd one occurring as a result
     *   of the Num Workflow Touches field update being executed
     */
    @isTest
    private static void validateAutomationCounters() {

        // Define parameters for the test
        ApexTruth__c truth = new ApexTruth__c(Name = 'Iron Man (TEST)');

        // Run the test
        Test.startTest();

        insert truth;

        // Validate results
        truth = [
            SELECT
                NumberOfDmlOperations__c,
                NumberOfWorkflowTouches__c,
                NumberOfTriggerTouches__c
            FROM ApexTruth__c
            WHERE Id = :truth.Id
        ];

        System.assertEquals(1, truth.NumberOfWorkflowTouches__c,
                ApexTruth__c.fields.NumberOfWorkflowTouches__c.getDescribe().getLabel());

        System.assertEquals(1, truth.NumberOfDmlOperations__c,
                ApexTruth__c.fields.NumberOfDmlOperations__c.getDescribe().getLabel());
    }
}