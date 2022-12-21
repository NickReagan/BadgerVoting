--------------------
--- BadgerVoting ---
--------------------

Config = {
    Prefix = '^6[^5Badger-Voting^6]^r ',
    StartVoteCommand = 'startvote',
    StartVoteAcePermission = 'BadgerVoting.Commands.startVote',
    Messages = {
        VoteStarted = '^3An AOP vote has been started... You have ^1{TIME} ^3to vote for the new AOP.', --Use {TIME} to display how many seconds/minutes people have to vote.
        VoteConcluded = '^3The AOP has been decided to be ^1{VOTE} ^3with a total of ^1{VOTE_COUNT} ^3votes.', -- Use {VOTE} to display the winning vote name. Use {VOTE_COUNT} to display how many votes that option got.
        VoteRecorded = "^3Your vote has been recorded: '{OPTION}'", --Use "{OPTION}" to display what the player choose.
        AlreadyVoted = '^1ERROR: You already voted you cheeky one ;)',
        NoVoteInProgress = '^1ERROR: There is currently no vote in progress :(',
    },
}