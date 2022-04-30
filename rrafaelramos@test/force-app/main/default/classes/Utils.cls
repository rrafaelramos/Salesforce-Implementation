/**
 * @author rrafaelramos
 */
public class Utils {

    public static Boolean isValidDocumentNumber ( String accountNumber, Integer sizeOfField ){

        if( accountNumber == null || String.isEmpty( accountNumber ) ) return false;

        return accountNumber.length() == sizeOfField;
    }

}
