pragma solidity ^0.5.0;
import "./DappToken.sol";

contract DappTokenSale {
    //State variables
    address payable admin;  //We don't want to expose the admin to public
    DappToken public tokenContract;
    uint256 public tokenPrice;
    uint256 public tokensSold;

    event Sell(address _buyer, uint256 _amount);


    constructor(DappToken _tokenContract, uint256 _tokenPrice) public {
        //Assign Administrator: a special account that has special priveleges on the blockchain
        admin = msg.sender;
        //Assign Token Contract
        tokenContract = _tokenContract;
        //Set the Token Price
        tokenPrice = _tokenPrice;
    }
    function mul(uint256 x, uint256 y) internal pure returns( uint256 z ){
        require(
            y == 0 || (z = x * y) / y == x,
            "Safe Multiplication."
        );
    }
    //Buy Tokens
    function buyTokens(uint256 _numberOfTokens) public payable {
        //Require that value is equal to tokenPrice
        require(
            msg.value == mul(_numberOfTokens, tokenPrice),
            "msg.value must be equal to tokenPrice."
            //msg.value is the amount of wei the function is sending
        );
        //Require that are enough tokens
        require(
            tokenContract.balanceOf(address(this)) >= _numberOfTokens,
            "Make sure there are enough tokens in smart contract before purchasing them."
        );
        //Require transfer is successfull
        require(
            tokenContract.transfer(msg.sender, _numberOfTokens),
            "Transfer must be successfull."
        );
        //Track number of tokensSold
        tokensSold += _numberOfTokens;
        //Trigger Sell Event
        emit Sell(msg.sender, _numberOfTokens);

    }

    //Ending Token DappTokenSale
    function endSale() public {
        // Require only admin can do this.
        require(
            msg.sender == admin,
            "Must be admin."
        );
        // Transfer tokens to admin
        require(
            tokenContract.transfer(admin, tokenContract.balanceOf(address(this))),
            "Require unsold tokens transferred to admin."
        );
        // Destroy contract
        selfdestruct(admin);
    }

}