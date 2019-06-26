@isTest
private class TriggerWorkflowContextTest {

    /**
     * `TriggerWorkflowContext.getInstance` in an Apex test is expected
     * to return an instance with all properties set to false.
     */
    @isTest
    private static void getInstance() {

        // When
        Test.startTest();

        TriggerWorkflowContext context = TriggerWorkflowContext.getInstance();

        // Then
        Test.stopTest();

        System.assertEquals(null, context.isInsert, 'isInsert');

        System.assertEquals(null, context.isUpdate, 'isUpdate');

        System.assertEquals(null, context.isDelete, 'isDelete');

        System.assertEquals(null, context.isBefore, 'isBefore');

        System.assertEquals(null, context.isAfter, 'isAfter');

        System.assertEquals(null, context.isUndelete, 'isUndelete');

        System.assertEquals(null, context.newRecords, 'new');

        System.assertEquals(null, context.newMap, 'newMap');

        System.assertEquals(null, context.oldRecords, 'old');

        System.assertEquals(null, context.oldMap, 'oldMap');
    }
}