/**
 * Additional trigger context that isn't readily available natively.
 *
 * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_context_variables.htm
 * @see https://salesforce.stackexchange.com/questions/159375/detecting-trigger-workflow-trigger
 */
global with sharing class TriggerContext {

    global Boolean isAfter { get; private set; }

    global Boolean isBefore { get; private set; }

    global Boolean isDelete { get; private set; }

    global Boolean isInsert { get; private set; }

    /**
     * Whether the trigger is handling `before update` and `after update`
     * events that were fired as a result of a workflow field update.
     */
    global Boolean isRerun { get; private set; }

    global Boolean isUndelete { get; private set; }

    global Boolean isUpdate { get; private set; }

    global List<SObject> oldRecords { get; private set; }

    global Map<Id, SObject> oldMap { get; private set; }

    global List<SObject> newRecords { get; private set; }

    global Map<Id, SObject> newMap { get; private set; }

    /**
     * Default constructor, which assumes this context object is being
     * initialized in the very first `Trigger.isBefore` context.
     */
    global TriggerContext() {
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
     * @return a new instance of `TriggerContext` based on current `Trigger`
     *         variables
     */
    global static TriggerContext getInstance() {
        return new TriggerContext()
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

    global TriggerContext setAfter(Boolean value) {
        this.isAfter = value;
        return this;
    }

    global TriggerContext setBefore(Boolean value) {
        this.isBefore = value;
        return this;
    }

    global TriggerContext setDelete(Boolean value) {
        this.isDelete = value;
        return this;
    }

    global TriggerContext setInsert(Boolean value) {
        this.isInsert = value;
        return this;
    }

    global TriggerContext setRerun(Boolean value) {
        this.isRerun = value;
        return this;
    }

    global TriggerContext setUndelete(Boolean value) {
        this.isUndelete = value;
        return this;
    }

    global TriggerContext setUpdate(Boolean value) {
        this.isUpdate = value;
        return this;
    }

    global TriggerContext setOld(List<SObject> value) {
        this.oldRecords = value;
        return this;
    }

    global TriggerContext setOldMap(Map<Id, SObject> value) {
        this.oldMap = value;
        return this;
    }

    global TriggerContext setNew(List<SObject> value) {
        this.newRecords = value;
        return this;
    }

    global TriggerContext setNewMap(Map<Id, SObject> value) {
        this.newMap = value;
        return this;
    }
}