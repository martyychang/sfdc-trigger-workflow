@isTest
private class TriggerWorkflowContextTest {

    /**
     * All of the `set` methods chained together in a fluent model should
     * work as expected to set known values, as examined afterward.
     *
     * @see https://en.wikipedia.org/wiki/Fluent_interface
     */
    @isTest
    private static void fluent() {

        // Given
        List<Account> givenNewRecords = new List<Account> {
            new Account(
                Id = '001000000000000000',
                Name = 'Acme Corporation (TEST)'
            )
        };

        Map<Id, Account> givenNewMap = new Map<Id, Account>(givenNewRecords);

        List<Account> givenOldRecords = new List<Account> {
            new Account(
                Id = '001000000000000000',
                Name = 'Acme, Inc. (TEST)'
            )
        };

        Map<Id, Account> givenOldMap = new Map<Id, Account>(givenOldRecords);

        // When
        Test.startTest();

        TriggerWorkflowContext context =
                TriggerWorkflowContext.getInstance()
                        .setInsert(true)
                        .setUpdate(true)
                        .setDelete(true)
                        .setBefore(true)
                        .setAfter(true)
                        .setUndelete(true)
                        .setNew(givenNewRecords)
                        .setNewMap(givenNewMap)
                        .setOld(givenOldRecords)
                        .setOldMap(givenOldMap);

        // Then
        Test.stopTest();

        System.assertEquals(true, context.isInsert, 'isInsert');

        System.assertEquals(true, context.isUpdate, 'isUpdate');

        System.assertEquals(true, context.isDelete, 'isDelete');

        System.assertEquals(true, context.isBefore, 'isBefore');

        System.assertEquals(true, context.isAfter, 'isAfter');

        System.assertEquals(true, context.isUndelete, 'isUndelete');

        System.assertEquals(givenNewRecords, context.newRecords, 'new');

        System.assertEquals(givenNewMap, context.newMap, 'newMap');

        System.assertEquals(givenOldRecords, context.oldRecords, 'old');

        System.assertEquals(givenOldMap, context.oldMap, 'oldMap');
    }

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