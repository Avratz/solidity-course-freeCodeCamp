// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 < 0.9.0;

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    
    mapping(address => uint256) public addressToAmountFunded;
    address owner;
    address[] public funders;
    address aggV3 = 0x9326BFA02ADD2366b30bacB125260Af641031331;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function fund() public payable {
        uint256 minUSD = 50 * 10 ** 18; // 50 usd to wei
        //if...
        require(getConvesionRate(msg.value) >= minUSD, "You need to spend more eth");
        //else ... revert
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }
    
    function getVersion() public view returns (uint256){
        AggregatorV3Interface priceFeed = AggregatorV3Interface(aggV3);
        return priceFeed.version();
    }
    
    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(aggV3);
        (, int256 answer,,,) = priceFeed.latestRoundData();
        return uint256(answer * 10000000000);
    }
    
    function getConvesionRate(uint256 ethAmount) public view returns (uint256){
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 100000000000000000;
        return ethAmountInUsd; 
    }
    
    modifier onlyOwner {
        require(msg.sender == owner);
        _; // if condition passes, executes the rest of the function in which was called
    }
    
    function withdraw() payable onlyOwner public  { //function with modifier
        msg.sender.transfer(address(this).balance);
        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}