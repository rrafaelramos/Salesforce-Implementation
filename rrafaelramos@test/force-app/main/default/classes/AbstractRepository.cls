/**
 * @author rrafaelramos
 */
public abstract class AbstractRepository {

    virtual
    public SObject save (SObject abstractObject) {

        if (abstractObject == null) return null;

        if (abstractObject.Id == null ) {
            insert abstractObject;
        } else {
            update abstractObject;
        }

        return abstractObject;
    }

    virtual
    public List<SObject> upsertObjects (List<SObject> objects) {

        try{

            upsert objects;

        }  catch (Exception ex) {

            System.debug( ex.getMessage() );

            return new List<SObject>();
        }

        return objects;
    }

}
