//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;
import "./CatHelper.sol";

contract CatFeed is CatHelper {

    function feed(uint catId) public onlyOwnerOf(catId){
        Cat storage myCat = cats[catId];
        require(_isReady(myCat));
        catFeedTimes[catId] =  SafeMath.add(catFeedTimes[catId], 1);
        _triggerCooldown(myCat);
        if(catFeedTimes[catId] % 10 == 0){
            uint newDna = myCat.dna - myCat.dna % 10 + 8;
            _createCat("zombie's son", newDna);
        }
    }
}