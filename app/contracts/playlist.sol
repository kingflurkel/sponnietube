/// @title Blocktu.be playlist contract.

contract blockPlaylist {
    
    struct Clip
    {
        uint duration; // duration
        bool visible;  // if true, anyone can see the clip
        bytes32 title; // the clip's title
        bytes32 description;   // the description
        address op; // account of the uploader
    }

    Clip[] public clips;

    // Fire the event clipUploaded(clipobject)
    // so our bot/gui can listen to it
    event clipUploaded(clipobject);

    // Add the clipobject to the clipcollection
    function uploadClip(clipobject){
    	clips[clipobject];
    	// fire an event we can listen to
    	event clipUploaded(clipobject);
    }
}