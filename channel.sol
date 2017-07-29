pragma solidity ^0.4.11;

contract Channel {
    address public sender;
    address public recipient;
    uint public startDate;
    uint public channelTimeout;

    function() payable {
        // Can add eth additionally
    }
    
    function Channel(address _recipient, uint timeout) payable {
        sender = msg.sender;
        recipient = _recipient;
        startDate = now;
        channelTimeout = timeout;
    }
    
    // Check if the hash is correct
    function getMessage(uint amount) constant returns (bytes32) {
        return sha3(this, amount);
    }
    
    function close(bytes32 message, uint8 v, bytes32 r, bytes32 s, uint amount) {
        // Only recipient can call the function
        require(msg.sender == recipient);
        bytes32 h = sha3("\x19Ethereum Signed Message:\n32", message);
        address signer = ecrecover(h, v, r, s);
        
        if (signer != sender) revert();
        if (sha3(this, amount) != message) revert();

        recipient.transfer(amount);
        selfdestruct(sender);
    }
    
    function ChannelTimeout(){
        // Only sender can call the function
        require(msg.sender == sender);
        if (startDate + channelTimeout > now) revert();
        selfdestruct(sender);
    }
}