/**
 * Class providing code coverage and functional validation for `Soql.Query`.
 */
@isTest
private class SoqlQueryTest {

    /**
     * Verify behavior of `getSelectClause` and `getFromClause` with
     * a simple query to SELECT Id,Name FROM Account WHERE Name = 'Acme'.
     */
    @isTest
    private static void getAccountWhereClause() {

        // Given
        Schema.SObjectType sobjectType = Account.getSObjectType();

        List<Schema.SObjectField> fields = new List<Schema.SObjectField> {
            Account.Id,
            Account.Name
        };

        Soql.Query query = new Soql.Query(fields, sobjectType);

        // When
        Test.startTest();

        query.expressWhere(Soql.expressEquals(Account.Name, 'Acme'));

        // Then
        Test.stopTest();

        System.assertEquals(
            'WHERE Name = \'Acme\'',
            query.getWhereClause()
        );

        System.assertEquals(
            'SELECT Id, Name FROM Account WHERE Name = \'Acme\'',
            query.toSoql()
        );
    }

    /**
     * Verify behavior of `getSelectClause` and `getFromClause` with
     * a simple query to SELECT Id,Name FROM Account
     */
    @isTest
    private static void getSelectFromAccountClause() {

        // Given
        Schema.SObjectType sobjectType = Account.getSObjectType();

        List<Schema.SObjectField> fields = new List<Schema.SObjectField> {
            Account.Id,
            Account.Name
        };

        // When
        Test.startTest();

        Soql.Query query = new Soql.Query(fields, sobjectType);

        // Then
        Test.stopTest();

        System.assertEquals(
            'SELECT Id, Name',
            query.getSelectClause()
        );

        System.assertEquals(
            'FROM Account',
            query.getFromClause()
        );
    }
}