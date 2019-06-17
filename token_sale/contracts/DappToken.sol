pragma solidity ^0.5.0;

contract DappToken {
    string public name = "DApp Token";
    string public symbol = "DAPP";
    string public standard = "DApp Token v1.0";
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;


    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    // Constructor
    constructor(
        uint256 _initSupply
    ) public{
        totalSupply = _initSupply;
        //allocate initial supply
        balanceOf[msg.sender] = _initSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success){
        //Exception if account doesn't have enough tokens
        require(
            balanceOf[msg.sender] >= _value,
            "Not enough tokens to transfer."
        );
        //Transfer the balance
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        //Must fire transfer event
        emit Transfer(msg.sender, _to, _value);
        //Return boolean
        return true;
    }

    //approve
    function approve(address _spender, uint256 _value) public returns (bool success){
        //handle allowance
        allowance[msg.sender][_spender] = _value;
        //handle approve event
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    //transferFrom
    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success){
        //Require _from has enough tokens
        require(
            _value <= balanceOf[_from],
            "Balance from account must be greater than value."
        );
        //Require allowance is big enough
        require(
            _value <= allowance[_from][msg.sender],
            "Balance from account must be greater than value."
        );
        //change the balance
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        //update the allowance
        allowance[_from][msg.sender] -= _value;
        //Transfer event
        emit Transfer(_from, _to, _value);
        //return a boolean
        return true;

    }

}