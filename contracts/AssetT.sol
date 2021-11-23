// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AssetT{
    //counter id
    uint id_prop;
    
    //Structs
    /**struct for propertis */
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
    
    /* Modificadores */
    /** check if a user exists */
     modifier isRegisterUser(){
         require((isUser[msg.sender] == false), "Este usuario ya esta registrado");
         _;
     }//works
     
     modifier isUserActive(){
         require(isUser[msg.sender] == true,"Este usuario no existe");
         _;
     }//works
     /**authorization */
     modifier isAutorize(address owner){
         require(owner == msg.sender, "403");
         _;
     }//works
     
    /**register a user, an identifier is required */
    function registerUser(string memory _user) public isRegisterUser(){
        user[msg.sender] = _user;
        isUser[msg.sender] = true;
        emit UserRegistered(msg.sender, _user);
    }//works
    /**function returned by a user */
    function getUser() public view returns(string memory){
        return user[msg.sender];
    }//works
    
    /*function registerProperty(string memory _uuid) public {
        require(isUser[msg.sender] == true,"Issuer not registered to register a certificate");
        issuerProperty[_uuid] = msg.sender;
        emit PropertyRegister(msg.sender, _uuid);
    }*/
    /**register a property, requires a hash of ipfs, name and price */
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
    
    /**get a property by id, the function is validated with authorization */
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

    /**get an array of properties for a user */
    function getProperty() public view returns(uint[] memory){
        return issuerPropertyRegister[msg.sender];
    }//funciona
    /**update the visibility of a property */
    function onVisible(bool _visible,uint _id) public isAutorize(issuerProperty[_id]){
        Property memory temp = propertyIdentifier[_id];
        temp.visible = _visible;
        propertyIdentifier[_id] = temp;
         emit propertyIssued(_id,msg.sender, temp.document_hash);
    }//funciona
    /**update the price of a property */
    function onUpdatePrice(uint _id, uint256 _newPrice) public isAutorize(issuerProperty[_id]){
        Property memory temp = propertyIdentifier[_id];
        temp.price = _newPrice;
        propertyIdentifier[_id] = temp;
        emit propertyIssued(_id,msg.sender, temp.document_hash);
    }//funciona
    
    /*function payProperty(uint _id,string memory _newipfs) public payable isAutorize(issuerProperty[_id]){
        address owner = issuerProperty[_id];
        Property memory temp = getIdProperty(_id);
        
        
        uint [] memory issuer =  issuerPropertyRegister[owner];
        temp.user = msg.sender;
        temp.visible = false;
        temp.document_hash = _newipfs;
        propertyIdentifier[_id]=temp;
        issuer[_id]=0;
        issuerProperty[_id]=msg.sender;
        issuerPropertyRegister[msg.sender].push(_id);
        emit propertyIssued(_id,msg.sender, temp.document_hash);
    }//no funciona, investigar que tranza con esta funcion*/
    
    
     
     
}