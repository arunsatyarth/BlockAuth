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


    mapping(address=> string) public login_details;
    mapping(string=> address)  login_details_rev;
    
    constructor() public {
        owner = msg.sender;
    }

    modifier restricted() {
        if (msg.sender == owner) _;
    }

    function grant_access()public restricted{

    }
    function login(string _uuid) public {
        login_details_rev[_uuid] = msg.sender;

    }
    function get_address(string _uuid) public returns (address) {
        return login_details_rev[_uuid];
    }
    

    function is_login(string _uuid) public returns (bool) {
        address _address = login_details_rev[_uuid];
        string _uuid_old = login_details[_address];
        if(keccak256(_uuid_old) == keccak256(_uuid)){
            return true;
        }
        return false;
    }
}
