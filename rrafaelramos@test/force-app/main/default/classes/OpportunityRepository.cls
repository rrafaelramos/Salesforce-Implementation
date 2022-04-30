/**
 * @author rrafaelramos
 */
public class OpportunityRepository extends AbstractRepository{
    
    public List<Opportunity> findByIds( Set<String> opportunitiesId ){

        return [ SELECT Id, Name, CloseDate, StageName, AccountId
                 FROM Opportunity
                 WHERE Id in: opportunitiesId ];

    }

    public Opportunity findById ( String opportunityId ) {

        List<Opportunity> opportunities = findByIds( new Set<String>{ opportunityId } );

        return opportunities != null && !opportunities.isEmpty() ? opportunities.get(0) : null;
    }

    public Opportunity findOneByAccountId( String accountId ){

        List<Opportunity> opportunities = [ SELECT Id, Name, CloseDate, StageName, AccountId
                 FROM Opportunity
                 WHERE AccountId = :accountId ];

        return opportunities != null && !opportunities.isEmpty() ? opportunities.get(0) : null;
    }

}