//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "CatHelper.sol";

contract CatAttack is CatHelper{

    function attack(uint catId,uint targetId) onlyOwnerOf(catId) external returns(uint){
        require(msg.sender != catToOwner[_targetId],'The target cat is yours!');
        Cat storage myCat = cats[catId];
        require(_isReady(myZombie),'Your zombie is not ready!');
        Cat storage enemyCat = cats[_targetId];
        if(whoWin(myCat,enemyCat)){
            myCat.winCount++;
            myCat.level++;
            enemyCat.lossCount++;
            hybrid(catId,targetDna);
            return catId;
        }else{
            myCat.lossCount++;
            enemyCat.winCount++;
            return targetId;
        }
    }

    function whoWin(Cat myCat,Cat enemyCat) internal returns(bool){
        if(myCat.power-enemyCat.defense>0){
            return true;
        }else{
            return false;
        }
    }

}