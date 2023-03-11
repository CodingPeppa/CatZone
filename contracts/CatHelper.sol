//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

import "./CatFactory.sol";

contract CatHelper is CatFactory {

    uint  feeToLevelUp = 0.0001 ether;

    uint changeNameFee =0.000000001 ether;

    //必须是这只猫的主人
    modifier onlyOwnerOf(uint catId){
        require(msg.sender == catToOwner[catId], 'cat is not yours');
        _;
    }
    //要大于这个等级
    modifier aboveLevel(uint level, uint catId) {
        require(cats[catId].level >= level,'Level is not sufficient');
        _;
    }

    function setLevelUpFee(uint fee) external onlyOwner {
        feeToLevelUp = fee;
    }

    //升级猫
    function levelUpCat(uint catId) external payable onlyOwnerOf(catId) {
            require(msg.value>feeToLevelUp,"fee is not sufficient");
          Cat storage cat=  cats[catId];
            cat.level++;
            cat.defense++;
            cat.power++;
    }
    //改名字
    function changeName(uint catId,string calldata name) external payable onlyOwnerOf(catId) aboveLevel(2,catId){
        require(msg.value>changeNameFee,"fee is not sufficient");
        cats[catId].name=name;
    }

    //获得所有猫的ID
    function getCatsByOwner(address owner) public view returns(uint[] memory data){
        uint[] memory result = new uint[](ownerCatCount[owner]);
        uint counter = 0;
        for (uint i = 0; i < cats.length; i++) {
            if (catToOwner[i] == owner) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }
    //重置到明日0点
    function _triggerCooldown(Cat storage cat) internal {
        cat.readyTime = uint32(block.timestamp + cooldownTime) - uint32((block.timestamp + cooldownTime) % 1 days);
    }
    //判断是否已经冷却就绪
    function _isReady(Cat storage cat) internal view returns (bool) {
        return (cat.readyTime <= block.timestamp);
    }

    //融合，产生新猫
    function hybrid(uint catId, uint _targetDna) internal onlyOwnerOf(catId) {
        Cat storage myCat = cats[catId];
        require(_isReady(myCat),'Cat is not ready');
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myCat.dna + _targetDna) / 2;
        newDna = newDna - newDna % 10 + 9;
        _createCat("NoName", newDna);
        _triggerCooldown(myCat);
    }


}