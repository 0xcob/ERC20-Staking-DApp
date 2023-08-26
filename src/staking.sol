pragma solidity ^0.8.19;

import "./Token.sol";
import "./Accounts.sol";

contract Staking is Accounts{

    // instance du contrat ERC20
    Token private token;

    // error messages
    error StakDoNotFinshed();
    error StakIsFinished();

    // Variables
    uint256 private times;
    uint256 private rateReward;
    address private owner;
    bool private paused;

    // Structure for balance's staker
    struct stakData{
        uint256 totalStaking;
        uint256 reward;
        uint duration;
        bool accountStak;
    }

    //Balance for staker
    mapping (address => stakData) private balance;

    constructor(Token _token, uint256 _times, uint256 _rateReward){
        token = _token;
        owner = msg.sender;
        times = _times;
        rateReward = _rateReward;
    }

    // group features for staking
    //get times for staking 
    function getTimes() external view returns(uint256){
        return times;
    }

    // get rate reward for staking
    function getRateReward() external view returns(uint256){
        return rateReward;
    }

    function getTotalStaking() external view returns(uint256) {
        address sender = msg.sender;
        require(sender != owner);
        require(balance[sender].accountStak, "Account do not exist");
        return balance[sender].totalStaking;
    }

    // go staking a amount 
    function goStaking(uint256 _amount) external{
        address sender = msg.sender;
        require(sender != owner);
        require(_amount > 0);
        require(token.balanceOf(sender) >= _amount);
        balance[sender].totalStaking = _amount;
        balance[sender].reward += _stak(sender);
        balance[sender].accountStak = true;
    }
    
    // stop staking
    function unStaking() external {
        address sender = msg.sender;
        _checkTime(sender);
        require(sender != owner, "Is owner");
        require(balance[sender].accountStak, "Account do note exist");
        require(paused, "Time is Over");
        stakData storage staker = balance[sender];
        uint256 reward = staker.reward;
        bool accountStak = staker.accountStak;
        delete balance[sender];
        token.transferStaking(sender, accountStak, reward);
    }

    //check the state of staking
    function checkStaking() external view returns(uint256){
        address sender = msg.sender;
        require(sender != owner);
        require(balance[sender].accountStak, "Account do note exist");
        return balance[sender].reward;
    }

    //Ending stak
    function endingStak() external {
        address sender = msg.sender;
        _checkTime(sender);
        require(sender != owner);
        require(balance[sender].accountStak, "Account do note exist");
        require(!paused, "Time is not Over");
        stakData storage staker = balance[sender];
        uint256 reward = balance[sender].reward;
        delete balance[sender];
        bool accountStak = staker.accountStak;
        token.transferStaking(sender, accountStak, reward);
        }


    // function for compute stak
    function _stak(address _account) internal returns(uint256){
        stakData storage staker = balance[_account];
        staker.duration = times-block.timestamp;
        return (staker.totalStaking*rateReward*staker.duration)/100;
    }

    // Function to check time 
    function _checkTime(address _account)  internal {
        if (balance[_account].duration > 0){
            paused = true;
        }
        else {
            paused = false;
        }
    }
}
