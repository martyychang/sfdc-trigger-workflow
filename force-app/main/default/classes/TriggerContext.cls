/**
 * Additional trigger context that isn't readily available natively.
 *
 * @see https://developer.salesforce.com/docs/atlas.en-us.apexcode.meta/apexcode/apex_triggers_context_variables.htm
 * @see https://salesforce.stackexchange.com/questions/159375/detecting-trigger-workflow-trigger
 */
global with sharing class TriggerContext {

    /**
     * Whether the trigger is handling `before update` and `after update`
     * events that were fired as a result of a workflow field update.
     */
    global Boolean isRerun { get; set; }

    /**
     * Default constructor, which assumes this context object is being
     * initialized in the very first `Trigger.isBefore` context.
     */
	global TriggerContext() {
        this.isRerun = false;		
	}
}