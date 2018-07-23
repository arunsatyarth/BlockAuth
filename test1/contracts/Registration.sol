pragma solidity ^0.4.24;

contract Registration {
    struct UserDetails {
        string username;
        string name;
        string profilepicture;
    }
    mapping(address => UserDetails) public users;
    

    function add_data(string _username,string _name,string _profilepicture ) public {
        users[msg.sender] = UserDetails(_username,_name,_profilepicture);

    }
}
