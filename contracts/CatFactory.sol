//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract CatFactory is Ownable {
    using SafeMath for uint;

    event NewCat(uint catId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    //冷却时间
    uint public cooldownTime = 1 days;
    uint public catPrice = 0.01 ether;
    uint public catCount = 0;

    struct Cat {
        string name;
        uint dna;
        uint16 winCount;
        uint16 lossCount;
        uint16 power;
        uint16 defense;
        uint32 level;
        uint32 readyTime;
    }

    Cat[] public cats;

    mapping(uint => address) public catToOwner;
    mapping(address => uint) public ownerCatCount;
    mapping(uint => uint) public catFeedTimes;//(id=>time)

    function _createCat(string memory name, uint dna) internal {
        cats.push(Cat(name, dna, 0, 0, 0, 0, 0, 0));
        uint catId = cats.length - 1;
        catToOwner[catId] = msg.sender;
        ownerCatCount[msg.sender] = ownerCatCount[msg.sender].add(1);
        catCount = catCount.add(1);
        emit NewCat(catId, name, dna);
    }

    function genRandomDna(string memory name, uint lastIndex) internal view returns (uint){
        uint randDna = uint(keccak256(abi.encodePacked(name, block.timestamp))) % dnaModulus;
        return randDna = randDna - randDna % 10 + lastIndex;
        //让最后一位为
    }

    function genRandomDna(string memory name) internal view returns (uint){
        uint randDna = uint(keccak256(abi.encodePacked(name, block.timestamp))) % dnaModulus;
        return randDna = randDna - randDna % 10;
    }

    function createCat(string memory name) public {
        require(ownerCatCount[msg.sender] == 0);
        //没有猫的时候免费调用。
        uint256 randomDna = genRandomDna(name, 0);
        //让最后一位为0
        _createCat(name, randomDna);
    }

    function buyCat(string memory name) public payable {
        require(ownerCatCount[msg.sender] > 0);
        require(msg.value >= catPrice);
        uint randDna = genRandomDna(name, 1);
        //让最后一位为1
        _createCat(name, randDna);
    }

}