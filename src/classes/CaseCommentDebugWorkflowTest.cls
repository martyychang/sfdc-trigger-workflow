/**
 * This class exists for functional validation of expected framework behavior
 * and can be delete from a Produciton organization.
 *
 * @see https://github.com/martyychang/sf-trigger-workflow/issues/1
 */
@isTest
private class CaseCommentDebugWorkflowTest {

    @isTest
    private static void insertComment() {

        // Given
        Case carrotCase = [
            SELECT Id, (SELECT Id FROM CaseComments)
            FROM Case
            WHERE Subject = 'My carrots are not fresh! (TEST)'
        ];

        System.assertEquals(1, carrotCase.CaseComments.size(),
                'Number of Case Comments');

        // When
        Test.startTest();

        insert new CaseComment(
                ParentId = carrotCase.Id,
                CommentBody = 'No, really they were from yesterday');

        // Then
        Test.stopTest();

        carrotCase = [
            SELECT Id, (SELECT Id FROM CaseComments)
            FROM Case
            WHERE Subject = 'My carrots are not fresh! (TEST)'
        ];

        System.assertEquals(2, carrotCase.CaseComments.size(),
                'Number of Case Comments');
    }

    @testSetup
    private static void setup() {
        
        // Create accounts
        Account acme = new Account(
                Name = 'Acme Corporation (TEST)');

        insert new List<Account> { acme };

        // Create contacts
        Contact bugs = new Contact(
                FirstName = 'Bugs',
                LastName = 'Bunny (TEST)',
                AccountId = acme.Id);

        insert new List<Contact> { bugs };

        // Create cases
        Case carrotCase = new Case(
                AccountId = acme.Id,
                ContactId = bugs.Id,
                Subject = 'My carrots are not fresh! (TEST)');

        insert new List<Case> { carrotCase };

        // Create case comments
        CaseComment carrotCaseComment1 = new CaseComment(
                ParentId = carrotCase.Id,
                CommentBody = 'They were procured yesterday.');

        insert new List<CaseComment> { carrotCaseComment1 };
    }
}