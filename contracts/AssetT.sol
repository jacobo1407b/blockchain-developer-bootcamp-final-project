// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AssetT{

    //Structs
    struct Users{
        address hasAddress;
        string id_user;
        string name;
        string lastName;
        string url_img;
    }

    struct Property{
        string id_property;
        string id_user;
        address hasAddress;
        bool visible;
        uint amount;
        string[] ipfs_hash;
        string name;
    }

    struct History{
        string id_history;
        string id_user;
        address hasAddress;
        uint amount;
        string[] ipfs_hash;
        string name;
        string id_property;
    }

    //mapping
    mapping(address => Users) user;
    mapping(address => Property) property;
    mapping(address => History) history;
    mapping(string => History) history2;

    //functions
    function registerUser() public{
        //should register a user
    }

    function registerPropiedad() public{
        //should register new property of user
    }

    function changeVisible() public{
        //should update private or public property
    }
    function transferProperty() public{
        //should sale property to another user
    }
    //gets
    function getUser(address _user) public view{
        //should return user
    }

    function getProperty() public view{
        //should return a array of propertys of a user
    }

    function getHistory() public view{
        //should return a history from user
    }

    function getAllHistoryProperty() public view{
        //should return all history from property
    }
}