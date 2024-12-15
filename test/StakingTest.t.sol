pragma solidity 0.8.20;

import "forge-std/Test.sol";
import {Matec} from "../src/Matec.sol";
import {Staking} from "../src/Staking.sol";

contract StakingTest is Test{
    Staking stake;
    Matec token;
    address owner = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
    address user2 = 0x95222290DD7278Aa3Ddd389Cc1E1d165CC4BAfe5;

    function setUp() external {
        vm.startPrank(owner);
        token = new Matec();
        token.transfer(owner, 500_000);
        token.transfer(user2, 500_000);
        stake = new Staking();
        vm.stopPrank();
    }

    /*
    //test sur le bon fonctionnement des features 
    //test sur la fonction de staking
    function test_onStaking() external{
        vm.prank(account2);
        stak.goStaking(200);
        vm.prank(account2);
        assertEq(stak.getTotalStaking(), 200);
        vm.prank(account2);
        vm.assume(stak.checkStaking() > 10);    
    }

    //test sur la fonctionnalite d'arret duu staking
    function test_unStaking() external{
        vm.prank(account2);
        stak.goStaking(200);
        vm.prank(account2);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), account2, 54);
        stak.unStaking();
        assertEq(token.balanceOf(account2), 2054);
    }

    //test sur checking du reward
    function test_checkStaking() external{
        vm.prank(account2);
        stak.goStaking(200);
        vm.prank(account2);
        assertEq(stak.checkStaking(), 54);
    }

    function test_endStaking() external {
        Token tk1 = new Token();
        tk1.transfer(account2, 2000);
        Staking st1 = new Staking(tk1, 1, 3);

        vm.prank(account2);
        st1.goStaking(200);
        vm.prank(account2);
        assertEq(st1.getTotalStaking(), 200);
        vm.expectEmit(true, true, false, true);
        emit Transfer(address(0), account2, 0);
        vm.prank(account2);
        st1.endingStak();
        assertEq(tk1.balanceOf(account2), 2000);
    }


    //Echec sur les tests
    //test sur la fin totale d'une processus de staking
    function testMultipleExpectReverts_endStak() external{
        vm.prank(account2);
        stak.goStaking(200);
        vm.expectRevert("Time is not Over");
        vm.prank(account2);
        stak.endingStak();
    } 


    function testExpectRevertNoReason_onStaking() external {
        vm.expectRevert(bytes(""));
        stak.goStaking(200);   

        vm.prank(account2);
        vm.expectRevert(bytes("problem in value"));
        stak.goStaking(0); 

        //revert amount > 1e7
        vm.prank(account2);
        vm.expectRevert("problem in value");
        stak.goStaking(1000000);

        //revert balande[msg.sender] < amount
        vm.prank(address(2));
        vm.expectRevert(bytes(""));
        stak.goStaking(200);
    }


    function testMultipleExpectReverts_unStaking() external {
        vm.prank(account2);
        stak.goStaking(200);

        //revert account don't exist
        vm.prank(address(3));
        vm.expectRevert("Account do not exist");
        stak.unStaking();

        // if Time is over
        Token tk1 = new Token();
        tk1.transfer(account2, 2000);
        Staking st1 = new Staking(tk1, 1, 3);

        vm.prank(account2);
        st1.goStaking(200);

        vm.prank(account2);
        vm.expectRevert("Time is Over");
        st1.unStaking();
    }

    function testFuzz_onStaking(uint64 _amount) external {
        vm.assume(_amount > 0);
        vm.assume(_amount < 2000);
        vm.prank(account2);
        stak.goStaking(_amount);
        vm.prank(account2);
        assertEq(stak.getTotalStaking(), _amount);
    } */
}
