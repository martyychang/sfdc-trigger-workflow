public with sharing class Soql {

    public static final String AND_OPERATOR = 'AND';

    public static final String COMMA_CHAR = ',';

    public static final String EQUALS_OPERATOR = '=';

    public static final String INCLUDES_OPERATOR = 'INCLUDES';

    public static final String SINGLE_QUOTE_CHAR = '\'';

    public static final String SPACE_CHAR = ' ';

    public static ConditionExpression expressAnd(
        ConditionExpression expr1,
        ConditionExpression expr2
    ) {
        return expressAnd(new List<ConditionExpression> { expr1, expr2 });
    }

    public static ConditionExpression expressAnd(
        List<ConditionExpression> exprs
    ) {
        return new AndExpression(exprs);
    }

    public static ConditionExpression expressEquals(
        Schema.SObjectField field,
        Object value
    ) {
        return new EqualsExpression(field, value);
    }

    public static ConditionExpression expressIncludes(
        Schema.SObjectField field,
        Object value
    ) {
        return new IncludesExpression(field, value);
    }

    public static List<String> getFieldLocalNames(
        List<Schema.SObjectField> fields
    ) {
        
        // Initialize the list of field names
        List<String> fieldNames = new List<String>();

        for (Schema.SObjectField eachField : fields) {
            fieldNames.add(eachField.getDescribe().getLocalName());
        }

        // Return the field names
        return fieldNames;
    }

    public static String inParentheses(String value) {
        return '(' + value + ')';
    }

    public static String inSingleQuotes(String value) {
        return SINGLE_QUOTE_CHAR + value + SINGLE_QUOTE_CHAR;
    }

    public class AndExpression implements ConditionExpression {

        private List<ConditionExpression> exprs;

        public AndExpression(List<ConditionExpression> exprs) {
            this.exprs = exprs;
        }

        public override String toString() {
            
            // Assume we have expressions to join
            String exprString = exprs[0].toString();

            // Join remaining elements
            for (Integer i = 1; i < exprs.size(); i++) {
                exprString = exprString
                        + SPACE_CHAR
                        + AND_OPERATOR
                        + SPACE_CHAR
                        + exprs[i];
            }

            // Return the total expression
            return exprString;
        }
    }
    
    public interface ConditionExpression {
        String toString();
    }

    public class EqualsExpression implements ConditionExpression {

        private Schema.DescribeFieldResult fieldDesc;
        private Object value;

        public EqualsExpression(
            Schema.SObjectField field,
            Object value
        ) {
            this(field.getDescribe(), value);
        }

        public EqualsExpression(
            Schema.DescribeFieldResult fieldDesc,
            Object value
        ) {
            this.fieldDesc = fieldDesc;
            this.value = value;
        }

        public override String toString() {
            return String.join(
                new List<String> {
                    this.fieldDesc.getLocalName(),
                    EQUALS_OPERATOR,
                    this.value instanceof String
                            ? inSingleQuotes((String)this.value)
                            : String.valueOf(this.value)
                },
                Soql.SPACE_CHAR
            );
        }
    }

    public class IncludesExpression implements ConditionExpression {

        private Schema.DescribeFieldResult fieldDesc;
        private List<String> values;

        public IncludesExpression(
            Schema.SObjectField field,
            Object value
        ) {
            this(
                field.getDescribe(),
                new List<String> { String.valueOf(value) }
            );
        }

        public IncludesExpression(
            Schema.DescribeFieldResult fieldDesc,
            List<String> values
        ) {
            this.fieldDesc = fieldDesc;
            this.values = values;
        }

        private List<String> getQuotedValues() {

            // Initialize the list
            List<String> quotedValues = new List<String>();

            // Build the list
            for (String value : this.values) {
                quotedValues.add(inSingleQuotes(value));
            }

            // Return the list
            return quotedValues;
        }

        public override String toString() {
            return String.join(
                new List<String> {
                    this.fieldDesc.getLocalName(),
                    INCLUDES_OPERATOR,
                    inParentheses(
                        String.join(
                            this.getQuotedValues(),
                            COMMA_CHAR
                        )
                    )
                },
                Soql.SPACE_CHAR
            );
        }
    }

    public class Query {
        
        private List<String> fieldNames;
        
        private String sobjectName;

        private ConditionExpression whereCondition;

        public Query(
            List<Schema.SObjectField> fields,
            Schema.SObjectType sobjectType
        ) {
            this(
                getFieldLocalNames(fields),
                sobjectType.getDescribe().getLocalName()
            );
        }

        public Query(List<String> fieldNames, String sobjectName) {
            this.fieldNames = fieldNames;
            this.sobjectName = sobjectName;
        }

        public Query expressWhere(ConditionExpression expr) {
            this.setWhereCondition(expr);
            return this;
        }

        public String getFromClause() {
            return 'FROM ' + this.sobjectName;
        }

        public String getSelectClause() {
            return 'SELECT ' + String.join(
                this.fieldNames,
                COMMA_CHAR + SPACE_CHAR
            );
        }

        public String getWhereClause() {
            return 'WHERE ' + this.whereCondition.toString();
        }

        public String toSoql() {

            // Initialize the list of clauses
            List<String> clauses = new List<String> {
                this.getSelectClause(),
                this.getFromClause()
            };

            // Add a WHERE clause if a condition exists
            if (this.whereCondition != null) {
                clauses.add(this.getWhereClause());
            }

            return String.join(clauses, SPACE_CHAR);
        }

        public void setWhereCondition(ConditionExpression value) {
            this.whereCondition = value;
        }
    }
}