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
     * @return whether the implementation supports recursion or not
     */
    Boolean isRecursive();

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