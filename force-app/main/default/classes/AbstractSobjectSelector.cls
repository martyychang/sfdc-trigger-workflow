public abstract class AbstractSobjectSelector {

    private DatabaseJockey jockey;

    abstract List<Schema.SObjectField> getSobjectFields();

    abstract Schema.SObjectType getSobjectType();

    public AbstractSobjectSelector() {
        this(DatabaseJockey.newInstance());
    }

    public AbstractSobjectSelector(DatabaseJockey jockey) {
        this.jockey = jockey;
    }

    protected Soql.Query getQuery() {
        return new Soql.Query(this.getSobjectFields(), this.getSobjectType());
    }

    protected List<SObject> execute(Soql.Query query) {
        return this.jockey.query(query.toString());
    }
}