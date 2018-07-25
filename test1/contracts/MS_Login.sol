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

    function grant_access(address addr,uint index)public restricted{
        License lic=access_rights[addr];
        if(index==0)
            lic.visual_studio=true;
        else if (index==1)
            lic.office365=true;
        access_rights[addr]=lic;
    }
    function login_promise(string _uuid) public restricted{
        login_details[msg.sender] = _uuid;
    }
    //put a safety net here. he sud only be able to edit the uuid where his address is written. otherwise he might arbitaryly edit somebody elses uuid
    function login(string _uuid) public {
        string _uuid2=login_details[msg.sender];
        if(keccak256(_uuid) == keccak256(_uuid2)){
            login_details_rev[_uuid] = msg.sender;
        }
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
