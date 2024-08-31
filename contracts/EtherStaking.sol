// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;


contract EtherStaking {
    struct Stake {
        uint256 amount;
        uint256 startTime;
    }

    mapping(address => Stake) public stakes;
    mapping(address => uint256) public rewards;

    uint256 public rewardRatePerSecond = 1; // Define the reward rate per second 

    event Staked(address indexed user, uint256 amount);
    event Withdrawn(address indexed user, uint256 amount, uint256 reward);

    // staking Function for users to stake Ether
    function stake() external payable {
        require(msg.value > 0, "Cannot stake zero Ether");

        if (stakes[msg.sender].amount > 0) {
            // User already has staked Ether, calculate the rewards for the previous stake
            uint256 reward = calculateReward(msg.sender);
            rewards[msg.sender] += reward;
        }

        // Record staking information
        stakes[msg.sender].amount += msg.value;
        stakes[msg.sender].startTime = block.timestamp;

        emit Staked(msg.sender, msg.value);
    }

    // Function to calculate the reward based on staking time
    function calculateReward(address user) public view returns (uint256) {
        Stake memory userStake = stakes[user];
        if (userStake.amount == 0) {
            return 0;
        }

        uint256 stakingDuration = block.timestamp - userStake.startTime;
        uint256 reward = stakingDuration * rewardRatePerSecond * userStake.amount / 1e18; // Adjust as per the reward logic

        return reward;
    }

    // Function to allow users to withdraw their staked Ether and rewards
    function withdraw() external {
        Stake memory userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No staked Ether to withdraw");

        uint256 reward = calculateReward(msg.sender) + rewards[msg.sender];
        uint256 totalAmount = userStake.amount + reward;

        // Reset the user's stake
        stakes[msg.sender].amount = 0;
        stakes[msg.sender].startTime = 0;
        rewards[msg.sender] = 0;

        // Transfer the staked Ether and reward back to the user
        (bool sent, ) = msg.sender.call{value: totalAmount}("");
        require(sent, "Failed to send Ether");

        emit Withdrawn(msg.sender, userStake.amount, reward);
    }
}