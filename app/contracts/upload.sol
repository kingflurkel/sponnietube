/// @title [TESTNET] Blocktu.be user contract.

/* 

    Blocktube has two tokens:
    a/ The BTToken
    b/ The ClipToken

    A blocktube clip has a limited supply of tokens (cliptoken).
    The ClipTokens are created by depositing BTToken ('like').
    
    After a certain treshold is met (end of the minting / crowdsale), 
    the next BTTokens (likes) will be distributed amongst 
    the token holders, in relation to the amount 
    of ClipTokens they hold.

*/

// we add the token contract so later, it knows what to do.
contract token { function transfer(address receiver, uint amount){  } }

contract blocktubeClip {
    
	// First, we need to declare some variables used in this contract.
    // The address of the original poster
    address public owner;

    // The percentage of shares the original poster is willing to trade
    uint public treshold;

    // The address of the Blocktube token contract
    uint public token;

    // The total supply of clipshares
    uint public clipshares;

    // Every clip has a json object, that's stored on IPFS.
    string public ipfsclipobject;
    
    // We have an array of 'funders', the early likes.
    Shareholder[] public shareholders;
    
    // The shareholder object
    struct Shareholder {
        address addr;
        uint shares;
    }

    // We have a boolean, crowdsaleClosed
    bool tresholdReached = false;

    // And of course, the array with likes / shares
    mapping(address => uint256) public balanceOf;

    // Then we define some events, where our contraclistener can listen to.
    //event tresholdReached(likesBalance);

    // And now, the function that runs when deploying this contract.
    function blocktubeClip(string _ipfsclipobject, uint _treshold, uint _clipshares){
        owner = msg.sender;
        treshold = _treshold;
        clipshares = _clipshares;
        ipfsclipobject = _ipfsclipobject;
        tresholdReached = false;
    }

    // When someone sends a like token to this contract's balance in the token contract,
    // the tokencontract will call this function
    function blocktubeTransfer(address _liker, uint _likeamount){
        // When the current amount of shareholders is lower than the treshold,
        // add the msg.sender to shareholders, and give him the amount of
        // shares left / number of shareholders.
        if(shareholders.length < treshold){
            uint shares = remainingCliptokens / shareholders.length;
            shareholders[shareholders.length++] = Shareholder[{addr: msg.sender, shares: shares}];
            remainingCliptokens = remainingCliptokens - amount;
        } else {
            // When we have reached the treshold, the likeamount is spread over the shareholders.
            // We invoke the token contract's function 'transfer'
            for (var i = shareholders.length - 1; i >= 0; i--) {
                token.tranfer(_liker, _likeamount / shareholders[i].shares); 
            }
        }
    }



}