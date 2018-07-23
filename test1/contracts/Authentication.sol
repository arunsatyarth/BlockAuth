pragma solidity ^0.4.23;

contract Authentication {
    address public owner;

    struct UserDetails {
        string username;
        string name;
        string profilepicture;
    }
    mapping(address=> UserDetails) public users;
    
    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }


}
