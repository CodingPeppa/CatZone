//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./CatHelper.sol";


contract CatOwnerShip is CatHelper, ERC721 {

   
    constructor() ERC721("Cats","ct") {}
      
    /**
   * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) override public view returns (uint256 balance){
        return  ownerCatCount(owner);
    }

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) override public view returns (address owner){
        return catToOwner(tokenId);
    }


    function _transfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override virtual {
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");

        _beforeTokenTransfer(from, to, tokenId, 1);

        // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
        require(ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");

        // Clear approvals from the previous owner
        delete super._tokenApprovals[tokenId];

    unchecked {
        // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
        // `from`'s balance is the number of token held, which is at least one before the current
        // transfer.
        // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
        // all 2**256 token ids to be minted, which in practice is impossible.
        ownerCatCount[from] -= 1;
        ownerCatCount[to] += 1;
    }
        catToOwner[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId, 1);
    }


}