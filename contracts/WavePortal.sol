// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint totalWaves; // a uint is just like an integer (a number). Solidity initialises totalWaves to 0. totalWaves is a state variable. 
    constructor() {
        console.log("Yo yo, I am a contract and I am smart" );
    }

    // This is similar to an API post function
    // It is being saved forever on the blockchain
    function wave() public {
        totalWaves += 1;
        // totalWaves is a state variable. When we change totalWaves its going to change here, and then its saved on the blockchain.
        // this is a state changing function. If someone calls this function on the blockchain it's going to change this variable. 
        console.log("%s is waved!", msg.sender); // %s means we are sending a string that you want to be printed out. Here, we are printing out msg.sender
    }

    // Retrieves total number of waves
    // This function is basically just reading something and sending back data
    // You can think of these functions like API endpoints
    function getTotalWaves() view public returns (uint) {
        console.log("We have %d total waves", totalWaves);
        return totalWaves;
    }

}