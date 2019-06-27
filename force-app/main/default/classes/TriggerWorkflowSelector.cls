public with sharing class TriggerWorkflowSelector
extends AbstractSobjectSelector {

    public static Schema.SObjectField getOnBeforeOrAfterField(
        TriggerWorkflowContext context
    ) {
        return context.isBefore
                ? TriggerWorkflow__mdt.IsOnBefore__c
                : context.isAfter
                        ? TriggerWorkflow__mdt.IsOnAfter__c
                        : null;
    }

    public static Schema.SObjectField getOnCrudField(
        TriggerWorkflowContext context
    ) {
        Schema.SObjectField field = null;

        if (context.isUpdate) {
            field = TriggerWorkflow__mdt.IsOnUpdate__c;
        }
        else if (context.isInsert) {
            field = TriggerWorkflow__mdt.IsOnInsert__c;
        }
        else if (context.isDelete) {
            field = TriggerWorkflow__mdt.IsOnDelete__c;
        }
        else if (context.isUndelete) {
            field = TriggerWorkflow__mdt.IsOnUndelete__c;
        }

        return field;
    }

    public List<Schema.SObjectField> getSobjectFields() {
        return new List<Schema.SObjectField> {
            TriggerWorkflow__mdt.DeveloperName,
            TriggerWorkflow__mdt.Id,
            TriggerWorkflow__mdt.IsActive__c,
            TriggerWorkflow__mdt.SobjectName__c
        };
    }

    public Schema.SObjectType getSobjectType() {
        return TriggerWorkflow__mdt.sobjectType;
    }

    public List<TriggerWorkflow__mdt> selectActiveBySobjectNameAndContext(
        String sobjectName,
        TriggerWorkflowContext context
    ) {
        return this.execute(
            this.getQuery().expressWhere(
                Soql.expressAnd(
                    new List<Soql.ConditionExpression> {
                        Soql.expressEquals(
                            TriggerWorkflow__mdt.SobjectName__c,
                            sobjectName
                        ),
                        Soql.expressEquals(
                            getOnBeforeOrAfterField(context),
                            true
                        ),
                        Soql.expressEquals(
                            getOnCrudField(context),
                            true
                        ),
                        Soql.expressEquals(
                            TriggerWorkflow__mdt.IsActive__c,
                            true
                        )
                    }
                )
            )
        );
    }
}