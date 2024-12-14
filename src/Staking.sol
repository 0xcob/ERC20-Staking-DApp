pragma solidity ^0.8.20;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Matec} from "./Matec.sol";

contract Staking is Ownable {
    // Variables
    uint256 duration;
    uint256 max_fees;
    bool paused;

    uint256 amountTotalStacked;

    // Structure for balance's staker
    struct stakeData{
        uint256 amountBlocked;
        uint256 time;
    }

    //Balance for staker
    mapping (address => stakeData) balance;

    constructor(address _owner) Ownable(_owner){
    }

    // get rate reward for staking
    function getRateReward() public view returns(uint256 rateReward){
        uint8 rateReward = IERC20(address(Token)).totalSupply() - amountTotalStacked * (10**18) / 10000;

    }

    function amountStaked(address staker) public view returns(uint256) {
        balance[staker].accountStaked;
    }

    // go staking a amount 
    function goStake(address staker, uint64 _amount) public{
        require(token.balanceOf(staker) >= _amount);
        balance[staker].amountBlocked += _amount;
        balance[staker].time = block.timestamp;
        IERC20(address(Token)).transfer(address(this), _amount);
    }
    
    // stop staking
    function rewardStatus(address staker) public pure returns(uint256 reward) {
        
        uint256 reward = _calculReward(staker);
    }

    function unStake(address staker) public {
        uint256 reward = _calculReward(staker);
        uint256 amount = stakeData[staker].amountBlocked + reward;
        stakeData[staker].times = 0;
        stakeData[staker].amountBlocked = 0;
        IERC20(address(Token)).transferFrom(address(this), staker, amount);
    }

    // function for compute stak
    function _calculReward(address staker) internal pure returns(uint256 reward){
        uint256 amount = stakeData[staker].amountBlocked;
        uint256 times = stakeData[staker].times;
        uint256 rate = getRateReward();
        uint256 reward = (amount * times * rate) / 10000;
    }
}
