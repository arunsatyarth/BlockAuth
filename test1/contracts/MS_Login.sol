pragma solidity ^0.4.24;

//contract for login into microsoft
contract MS_Login {
    address public owner;

    struct License {
        bool visual_studio;
        bool office365;
        uint ring;
    }
    mapping(address=> License) public access_rights;

    //Authentication is a 2 step process. 
    //Step1: You send an address to the server and say that this is your address
    //Step2: You have to prove it. You can do this by sending your private key to the server but you dont want to do that. 
    //So it happens in the following way.
    //Server maintain a map of address to uuid and says now mention this uuid in any transaction that comes from this address
    //At client side take that uuid and from that address, create a transaction by calling login mentioning the uuid
    //At client we  will store the uuid to address map in the contract
    //Authentication wil only be possible if the uuid pointed address is the same one which made the change in  login_details_rev

    mapping(address=> string)  public login_details;//filled by server
    mapping(string=> address)   login_details_rev;//filled by client
    
    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    //Executed by server
    function grant_access()public restricted{

    }
    //Executed by client. Not by server
    function login(string _uuid) public {
        login_details_rev[_uuid] = msg.sender;

    }

    function address_from_uuid(string _uuid) public returns (address) {
        return login_details_rev[_uuid];
    }


    //tells if a uuid has got a successful login. if yes read the coresponding address from login_details_rev
    function is_login(string _uuid) public returns (bool) {
        address _address = login_details_rev[_uuid];
        string _uuid_old = login_details[_address];
        if(keccak256(_uuid_old) == keccak256(_uuid)){
            return true;
        }
        return false;
    }
}
