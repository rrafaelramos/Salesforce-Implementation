/**
 * @author rrafaelramos
 */
public class OpportunityEnricher {
    
    public static final String PARTNER_OPP_ANOTATION = ' – opp Parceiro';

    public Opportunity withNameCloseDateAndStageName( Opportunity opportunity, Account account, Date closeDate, String stageName ){

        opportunity.Name = account.Name + PARTNER_OPP_ANOTATION;
        opportunity.CloseDate = CloseDate;
        opportunity.StageName = StageName;
        opportunity.AccountId = account.Id;

        return opportunity;
    }

}
