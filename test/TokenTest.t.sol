pragma solidity 0.8.19;

import "forge-std/Test.sol";
import {Token} from "../src/Token.sol";
import {Accounts} from "../src/Accounts.sol";

contract TokenTest is Test, Accounts{
    Token token;
    event Transfer(address indexed _from, address indexed _to, uint256 _amount);

    function setUp() external {
        token = new Token();
        token.transfer(account2, 2000);
    }

    // fonction de test pour minter des tokens vers la balance du owner
    function test_balance() external{
        assertEq(token.balanceOf(account1), 1998000);
        assertEq(token.balanceOf(account2), 2000);
    }

    function test_transferStaking() external{
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), account2, 200);
        token.transferStaking(account2, true, 200);
        assertEq(token.balanceOf(account2), 2200);
    }

    //test fails
    function testMultipleExpectReverts_transferStaking() external{
        vm.expectRevert("This address don't account for staking");
        token.transferStaking(account2, false, 200);
        vm.expectRevert("Error in address");
        token.transferStaking(address(0), false, 200);
    }

    // Fuzzing test
    function testFuzz_transferStaking(address _to, bool _accountStak, uint256 _amount) external {
        vm.assume(_to != address(0));
        vm.assume(_accountStak);
        vm.assume(_amount >0);
        vm.assume(_amount < 1e7);
        token.transferStaking(_to, true, _amount);
        assertEq(token.balanceOf(_to), _amount);
    }
}
