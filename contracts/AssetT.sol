// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AssetT{
    //Structs
    uint id_prop;
    
    
    struct Property{
        address user;
        bool visible;
        uint256 price;
        string ipfs_hash;
        string name;
        string document_hash;
    }



    mapping(address => Property[]) properties;
    mapping(address => string) user;
    mapping(address => bool) isUser;
    mapping(uint => address) issuerProperty;
    mapping(uint => Property) propertyIdentifier;
    mapping(address => uint[]) issuerPropertyRegister;
    
    event UserRegistered(address indexed isuser, string id);
    event PropertyRegister(address indexed isuser, string IPFS);
    event propertyIssued(uint indexed property,address indexed user, string indexed document);
    
     modifier isRegisterUser(){
         require((isUser[msg.sender] == false), "Este usuario ya esta registrado");
         _;
     }//funciona
     
     modifier isUserActive(){
         require(isUser[msg.sender] == true,"Este usuario no existe");
         _;
     }//funciona
     modifier isAutorize(address owner){
         require(owner == msg.sender, "403");
         _;
     }//funciona
     
    
    function registerUser(string memory _user) public isRegisterUser(){
        user[msg.sender] = _user;
        isUser[msg.sender] = true;
        emit UserRegistered(msg.sender, _user);
    }//funciona
    
    function getUser() public view returns(string memory){
        return user[msg.sender];
    }//funciona
    
    /*function registerProperty(string memory _uuid) public {
        require(isUser[msg.sender] == true,"Issuer not registered to register a certificate");
        issuerProperty[_uuid] = msg.sender;
        emit PropertyRegister(msg.sender, _uuid);
    }*/
    function emitRegisterProperty(string memory _uuid, string memory _img_uid,string memory _name,uint256 _value) public isUserActive(){
        
        Property memory proper;
        uint id = ++id_prop;
        
         proper.user = msg.sender;
         proper.visible = false;
         proper.price = _value;
         proper.ipfs_hash = _img_uid;
         proper.name = _name;
         proper.document_hash = _uuid;
         propertyIdentifier[id] = proper;
         issuerProperty[id]=msg.sender;
         issuerPropertyRegister[msg.sender].push(id);
         emit propertyIssued(id,msg.sender, _uuid);
        
    }//funciona
    
    function getIdProperty(uint _id) public view isAutorize(issuerProperty[_id]) 
    returns(address  direccion,bool visible,uint256 price, string memory ipfs,string memory name, string memory document){
       Property memory prop = propertyIdentifier[_id];
    
       direccion = prop.user;
       visible = prop.visible;
       price = prop.price;
       ipfs = prop.ipfs_hash;
       name = prop.name;
       document = prop.document_hash;
        
       return (direccion,visible,price,ipfs,name,document);
    }//funciona

    function getProperty() public view returns(uint[] memory){
        return issuerPropertyRegister[msg.sender];
    }//funciona
    
    function onVisible(bool _visible,uint _id) public isAutorize(issuerProperty[_id]){
        Property memory temp = propertyIdentifier[_id];
        temp.visible = _visible;
        propertyIdentifier[_id] = temp;
         emit propertyIssued(_id,msg.sender, temp.document_hash);
    }//funciona
    
    function onUpdatePrice(uint _id, uint256 _newPrice) public isAutorize(issuerProperty[_id]){
        Property memory temp = propertyIdentifier[_id];
        temp.price = _newPrice;
        propertyIdentifier[_id] = temp;
        emit propertyIssued(_id,msg.sender, temp.document_hash);
    }//funciona
    
    function payProperty(uint _id,string memory _newipfs, address payable dire) payable public {
        //address owner = issuerProperty[_id];
         require(dire != address(0));
         dire.transfer(msg.value);

        Property memory temp = propertyIdentifier[_id];
        
        //uint [] memory issuer =  issuerPropertyRegister[owner];
        temp.user = msg.sender;
        temp.visible = false;
        temp.document_hash = _newipfs;
        propertyIdentifier[_id]=temp;
        //issuer[_id]=0;
        issuerProperty[_id]=msg.sender;
        issuerPropertyRegister[msg.sender].push(_id);
        
        emit propertyIssued(_id,msg.sender, temp.document_hash);
    } 

    /*function tansf(address payable dire) payable public{
        //uint value = msg.value;
        //address payable dire = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
        dire.transfer(msg.value);
    }*/  
}