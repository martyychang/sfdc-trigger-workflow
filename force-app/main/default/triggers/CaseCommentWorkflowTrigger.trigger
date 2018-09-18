/**
 * This trigger exists for functional validation of expected framework behavior
 * and can be delete from a Produciton organization.
 *
 * @see https://github.com/martyychang/sf-trigger-workflow/issues/1
 */
trigger CaseCommentWorkflowTrigger on CaseComment (
        before insert, after insert,
        before update, after update,
        before delete, after delete, after undelete) {

    // For readability, get a handle on the TriggerService object
    // for this Sobject type
    TriggerService service = TriggerService.getInstance(
            Schema.sobjectType.CaseComment.getName());

    // Process all of the trigger workflows
    service.process(new List<Type> {
        CaseCommentDebugWorkflow.class
    });
}