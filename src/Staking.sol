pragma solidity ^0.8.20;

import {Ownable} from "./utils/Ownable.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
import {Matec} from "./Matec.sol";

contract Staking is Ownable {
    using SafeERC20 for IERC20;

    // Variables
    uint256 duration;
    uint256 max_fees;
    bool paused;
    Matec matec;

    uint256 amountTotalStacked;

    // Structure for balance's staker
    struct stakeData{
        uint256 amountBlocked;
        uint256 time;
    }

    //Balance for staker
    mapping (address => stakeData) balance;

    constructor() Ownable(msg.sender){}

    // get rate reward for staking
    function getRateReward() public view returns(uint256 rateReward){
        rateReward = IERC20(address(matec)).totalSupply() - amountTotalStacked * (10**18) / 10000;

    }

    function amountStaked(address staker) public view returns(uint256) {
        return balance[staker].amountBlocked;
    }

    // go staking a amount 
    function goStake(address staker, uint64 _amount) public{
        require(IERC20(matec).balanceOf(staker) >= _amount);
        balance[staker].amountBlocked += _amount;
        balance[staker].time = block.timestamp;
        IERC20(address(matec)).safeTransfer(address(this), _amount);
    }
    
    // stop staking
    function rewardStatus(address staker) public view returns(uint256 reward) {
        reward = _calculReward(staker);
    }

    function unStake(address staker) public {
        uint256 reward = _calculReward(staker);
        uint256 amount = balance[staker].amountBlocked + reward;
        balance[staker].time = 0;
        balance[staker].amountBlocked = 0;
        IERC20(matec).safeTransferFrom(address(this), staker, amount);
    }

    // function for compute stak
    function _calculReward(address staker) internal view returns(uint256 reward){
        uint256 amount = balance[staker].amountBlocked;
        uint256 times = balance[staker].time;
        uint256 rate = getRateReward();
        reward = (amount * times * rate) / 10000;
    }
}
