global interface TriggerWorkflow {

    /**
     * @return whether the workflow should execute, based on the presence
     *         or absence of records which meet the entry criteria
     */
    Boolean evaluate();

    /**
     * Do something useful
     */
    void execute();

    /**
     * @return whether the implementation is active and should be evaluated.
     *.        This should be integrated with the Trigger Workflow custom
     *         metadata type for clicks-not-code control over which workflows
     *         can be evaluated and executed and which ones cannot.
     */
    Boolean isActive();

    /**
     * @return whether the implementation supports recursion or not
     */
    Boolean isRecursive();

    /**
     * @return whether the implementation allows actions to be executed
     *         when the single trigger handles `before update` and
     *         `after update` events fired as a result of a field update
     */
    Boolean isRerunnable();

    /**
     * Apply a specific trigger context to this workflow, and return the
     * workflow in this new context for ease of chaining.
     *
     * @param context The new trigger context
     *
     * @return the workflow with the new context applied
     */
    TriggerWorkflow withContext(TriggerContext context);
}