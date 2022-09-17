// fund the user
//withdraw the funded money
//set a minimum funding value

//SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
//import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./PriceConverter.sol";

    
contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUSD = 50*1e18;
    address[] public funders;
    mapping(address => uint256) public addressToAmountFunded;

    address public owner;

    constructor(){
    owner = msg.sender;
    }



//payable function is like wallet which store the eth
    function fundMe() public payable{
        //setting up to send minimum eth
        require(msg.value.getConversionRate() >= minimumUSD, "please pay more than 1 eth");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] = msg.value;
    }

//withdraw the ether
    function withdraw() public onlyOwner {

        for(uint256 funderIndex =0; funderIndex<funders.length;funderIndex++ ){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder]=0;
        }
    //reset the array
        funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value:address(this).balance}("");
        require(callSuccess,"call Failed");
    }

//modifier will tell to execute modiefier code then execute rest of the code or vice versa
    modifier onlyOwner{
    require(msg.sender == owner, "Only owner can withdraw the money!");
    _;
    }    

    
}
