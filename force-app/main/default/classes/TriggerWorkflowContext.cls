/**
 * Additional trigger context that isn't readily available natively.
 *
 * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_context_variables.htm
 * @see https://salesforce.stackexchange.com/questions/159375/detecting-trigger-workflow-trigger
 */
global with sharing class TriggerWorkflowContext {

    global Boolean isAfter;

    global Boolean isBefore;

    global Boolean isDelete;

    global Boolean isInsert;

    /**
     * Whether the trigger is handling `before update` and `after update`
     * events that were fired as a result of a workflow field update.
     */
    global Boolean isRerun;

    global Boolean isUndelete;

    global Boolean isUpdate;

    global List<SObject> oldRecords;

    global Map<Id, SObject> oldMap;

    global List<SObject> newRecords;

    global Map<Id, SObject> newMap;

    /**
     * Default constructor, which assumes this context object is being
     * initialized in the very first `Trigger.isBefore` context.
     */
    global TriggerWorkflowContext() {
        this.isRerun = false;
        this.isInsert = false;
        this.isUpdate = false;
        this.isDelete = false;
        this.isBefore = false;
        this.isAfter = false;
        this.isUndelete = false;
        this.newRecords = null;
        this.newMap = null;
        this.oldRecords = null;
        this.oldMap = null;
    }

    /**
     * @return a new instance of `TriggerWorkflowContext` based on current `Trigger`
     *         variables
     */
    global static TriggerWorkflowContext getInstance() {
        return new TriggerWorkflowContext()
                .setInsert(Trigger.isInsert)
                .setUpdate(Trigger.isUpdate)
                .setDelete(Trigger.isDelete)
                .setBefore(Trigger.isBefore)
                .setAfter(Trigger.isAfter)
                .setUndelete(Trigger.isUndelete)
                .setNew(Trigger.new)
                .setNewMap(Trigger.newMap)
                .setOld(Trigger.old)
                .setOldMap(Trigger.oldMap);
    }

    global Boolean isRerunEnabled() {
        return this.isBefore && this.isUpdate
                && TriggerWorkflowUtil.isRerunSupported(
                    this.newRecords[0].getSObjectType()
                );
    }

    global TriggerWorkflowContext setAfter(Boolean value) {
        this.isAfter = value;
        return this;
    }

    global TriggerWorkflowContext setBefore(Boolean value) {
        this.isBefore = value;
        return this;
    }

    global TriggerWorkflowContext setDelete(Boolean value) {
        this.isDelete = value;
        return this;
    }

    global TriggerWorkflowContext setInsert(Boolean value) {
        this.isInsert = value;
        return this;
    }

    global TriggerWorkflowContext setRerun(Boolean value) {
        this.isRerun = value;
        return this;
    }

    global TriggerWorkflowContext setUndelete(Boolean value) {
        this.isUndelete = value;
        return this;
    }

    global TriggerWorkflowContext setUpdate(Boolean value) {
        this.isUpdate = value;
        return this;
    }

    global TriggerWorkflowContext setOld(List<SObject> value) {
        this.oldRecords = value;
        return this;
    }

    global TriggerWorkflowContext setOldMap(Map<Id, SObject> value) {
        this.oldMap = value;
        return this;
    }

    global TriggerWorkflowContext setNew(List<SObject> value) {
        this.newRecords = value;
        return this;
    }

    global TriggerWorkflowContext setNewMap(Map<Id, SObject> value) {
        this.newMap = value;
        return this;
    }
}