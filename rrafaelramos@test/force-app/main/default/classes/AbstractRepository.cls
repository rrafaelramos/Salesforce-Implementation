/**
 * @author rrafaelramos
 */
public virtual class AbstractRepository {

    virtual
    public SObject save (SObject aggregate) {

        if (aggregate == null) return null;

        if (aggregate.Id == null ) {
            insert aggregate;
        } else {
            update aggregate;
        }

        return aggregate;
    }

}
