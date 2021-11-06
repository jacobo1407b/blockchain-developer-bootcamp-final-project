// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AssetT{
    uint private id_property;
    uint private id_history;
    //Structs
    struct Property{
        uint id_property;
        string id_user;
        address hasAddress;
        bool visible;
        uint amount;
        string ipfs_hash;
        string name;
    }

    struct History{
        string id_history;
        string id_user;
        address hasAddress;
        uint amount;
        string ipfs_hash;
        string name;
        string id_property;
    }

    Property[] properties;
    History[] history;

    //mapping
    mapping(address => string) user;
    mapping(address => bool) isUser;
    //events
     event UserRegistered(address indexed user, string id_hash);

    //functions
    function registerUser(string _idHash) public{
        require((isUser[msg.sender] == false), "Este usuario ya esta registrado");
        user[msg.sender] = _idHash;
        isUser[msg.sender] = true;
        emit UserRegistered(msg.sender, _idHash);
    }

    function registerPropiedad(bool memory _visibe,uint memory _amount,string memory _name, string memory _ipfs) public{
        //should register new property of user
        require(isUser[msg.sender] == true, "Este usuario no esta registrado");
        properties.push(Property(id_property,user[msg.sender],msg.sender,_visibe,_amount,_ipfs,_name));
        id_property ++;
    }
    /*function getProperty(uint _id) public view returns(Property){
        require(properties[_id].visible == true, "La propiedad no esta disponible");
        return properties[_id];
    }*/
    function findProperty(uint _id) internal view returns(uint){
        for(uint i = 0; i < properties.length; i++){
            if(properties[i].id_property == _id){
                return i;
            }
        }
        revert("No existe la propiedad");
    }

    function changeVisible(uint _id) public{
        //should update private or public property
        uint index = findProperty(_id);
        require(properties[index].hasAddress == msg.sender, "No tienes permisos para modificar esta propiedad");
        properties[index].visible = !properties[index].visible;
    }
    function transferProperty(uint _id, string _newhash, address _newowner) public{
        //should sale property to another user
        uint index = findProperty(_id);
        require(properties[index].hasAddress == msg.sender, "No tienes permisos para modificar esta propiedad");
        require(isUser[_newowner] == true, "Este usuario no esta registrado");
        require(isUser[msg.sender] == true, "Este usuario no esta registrado");
        Property temp = properties[index];
        properties[index].hasAddress = _newowner;
        properties[index].id_user = _newhash;
        history.push(History(
            id_history,
            temp.id_user,
            temp.hasAddress,
            temp.amount,
            temp.ipfs_hash,
            temp.name,
            temp.id_property
        ));
    }
    //gets
    function getUser(address _user) public view returns(string){
        //should return user
        return user[_user];
    }

    function getPropertysUser() public view returns(Property[]){
        //should return a array of propertys of a user

    }

    function getHistory() public view returns(History[]){
        //should return a history from user

    }

    function getAllHistoryProperty() public view{
        //should return all history from property
    }
}