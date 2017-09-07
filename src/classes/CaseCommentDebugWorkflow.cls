/**
 * This class exists for functional validation of expected framework behavior
 * and can be delete from a Produciton organization.
 *
 * @see https://github.com/martyychang/sf-trigger-workflow/issues/1
 */
public class CaseCommentDebugWorkflow extends AbstractSobjectWorkflow {

    public override void executeAfter() {
        System.debug('AFTER');
    }

    public override void executeBefore() {
        System.debug('BEFORE');
    }

    public override String getClassName() {
        return CaseCommentDebugWorkflow.class.getName();
    }

    public override Boolean qualify(Sobject newRecord, Sobject oldRecord) {
        return false;
    }
}