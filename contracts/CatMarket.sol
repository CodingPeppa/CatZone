//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./CatOwnerShip.sol";

contract CatMarket is CatOwnerShip {
    struct CatSales {
        address payable seller;
        uint price;
    }

    mapping(uint => CatSales) public catShop;
    uint shopCatCount;
    uint public tax = 1 * 10 ** 15 wei;
    uint public minPrice = 1 * 10 ** 15  wei;


    event SellCat(uint indexed zombieId, address indexed seller);
    event BuyShopCat(uint indexed zombieId, address indexed buyer, address indexed seller);

    function setTax(uint _value) public onlyOwner {
        tax = _value;
    }

    function setMinPrice(uint _value) public onlyOwner {
        minPrice = _value;
    }

    function getShopCats() external view returns (uint[] memory) {
        uint[] memory result = new uint[](shopCatCount);
        uint counter = 0;
        for (uint i = 0; i < cats.length; i++) {
            if (catShop[i].price != 0) {
                result[counter] = i;
                counter++;
            }
        }
        return result;
    }

    function sellCats(uint catId, uint price) external onlyOwnerOf(catId) {
        require(price >= minPrice + tax, 'Your price must > minPrice+tax');
        catShop[catId] = CatSales(payable(msg.sender), price);
        shopCatCount = SafeMath.add(1);
        emit SellCat(catId, msg.sender);
    }

    function buyCatFromShop(uint catId) public payable {
        require(msg.value >= catShop[catId].price, 'No enough money');
        //转移
        safeTransferFrom(catShop[catId].seller, msg.sender, catId);
        delete catShop[catId];
        shopCatCount = SafeMath.sub(1);
        emit BuyShopCat(catId, msg.sender, catShop[catId].seller);
    }


}