/**
 * @author rrafaelramos
 */
public class OpportunityService {
    
    public OpportunityEnricher enricher;

    public OpportunityService( ){

        enricher = new OpportunityEnricher();

    }

    public void createOpportunityForPartnerAccount( List<Account> partnerAccounts ){

        if( partnerAccounts == null || partnerAccounts.isEmpty() ) return;

        List<Opportunity> opportunities = new List<Opportunity>();

        for( Account account : partnerAccounts ){

            Opportunity opportunity = new Opportunity( );

            Date closeDate = System.now().date().addDays( 30 );

            opportunity = enricher.withNameCloseDateAndStageName(opportunity, account, closeDate, 'Qualification');

            opportunities.add( opportunity );
        }

        if (opportunities != null && !opportunities.isEmpty()) insert opportunities;
    }

}
