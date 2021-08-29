// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint totalWaves; // a uint is just like an integer (a number). Solidity initialises totalWaves to 0. totalWaves is a state variable. 
    uint private seed;
    
    // A little magic, Google what events are in Solidity!
    event NewWave(address indexed from, uint timestamp, string message);

    // I created a struct here named Wave.
    // A struct is basically a custom datatype where we can customize what we want to hold inside it
    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint timestamp; // THe timestamp when the user waved. 
    }

    // I declare a variable waves that lets me store an array of structs. 
    // This is what lets me hold all the waves anyone ever sends to me!
    Wave[] waves;

    // This is an address => uint mapping, meaning I can associate an address with a number!
    // In this case, I'll be storing the address w/ the last time the user waved at us.
    mapping(address => uint) public lastWavedAt;
    
    constructor() payable {
        console.log("We have been constructed!" );
    }

    // This is similar to an API post function
    // It is being saved forever on the blockchain
    // You'll notice I changed the wave function a little as well and now it requires a string called message.
    // This is the message our user sends us from the frontend!
    function wave(string memory _message) public {
        // We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored.
        require(lastWavedAt[msg.sender] + 10 seconds < block.timestamp, "Must wait 10 seconds before waving again.");

        // Update the current timestamp we have for the user.
        lastWavedAt[msg.sender] = block.timestamp;
        
        totalWaves += 1;
        // totalWaves is a state variable. When we change totalWaves its going to change here, and then its saved on the blockchain.
        // this is a state changing function. If someone calls this function on the blockchain it's going to change this variable. 
        console.log("%s waved w/ message %s", msg.sender, _message); // %s means we are sending a string that you want to be printed out.

        // This is where I actually store the wave data in the array.
        waves.push(Wave(msg.sender, _message, block.timestamp));

        // I added some fanciness here, Google it and try to figure out what it is!
        emit NewWave(msg.sender, block.timestamp, _message);

        // Generate a PSEUDO random number in the range 100.
        uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %s", randomNumber);

        // Set the generated random number as the seed for the next wave.
        seed = randomNumber;

        // Give a 50% chance that the user wins the prize.
        if(randomNumber < 50) {
            console.log("%s won!", msg.sender);
            uint prizeAmount = 0.0001 ether;
            require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has. ");
            (bool success,) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

    }

    // I added a function getAllWaves which will return the struct array waves to us. This will make it easy to retrieve
    // the waves from out website!
    function getAllWaves() view public returns (Wave[] memory) {
        return waves;
    }

    // Retrieves total number of waves
    // This function is basically just reading something and sending back data
    // You can think of these functions like API endpoints
    function getTotalWaves() view public returns (uint) {
        return totalWaves;
    }

}