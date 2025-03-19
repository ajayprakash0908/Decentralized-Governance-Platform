module MyModule::Governance {

    use aptos_framework::signer;
    use std::vector;
    use std::string::String;

    /// Struct representing a proposal.
    struct Proposal has store, key {
        description: String,
        votes: u64,
        voters: vector<address>,
    }

    /// Function to create a new proposal.
    public fun create_proposal(owner: &signer, description: String) {
        let proposal = Proposal {
            description,
            votes: 0,
            voters: vector::empty(),
        };
        move_to(owner, proposal);
    }

    /// Function to vote on a proposal.
    public fun vote(voter: &signer, proposal_owner: address) acquires Proposal {
        let proposal = borrow_global_mut<Proposal>(proposal_owner);
        let voter_address = signer::address_of(voter);
        
        // Ensure the voter hasn't already voted
        if (!vector::contains(&proposal.voters, &voter_address)) {
            vector::push_back(&mut proposal.voters, voter_address);
            proposal.votes = proposal.votes + 1;
        }
    }
}
