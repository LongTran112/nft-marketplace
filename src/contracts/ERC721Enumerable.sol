// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721{

    uint256[] private _allTokens;

    //mapping from tokenId to position in _allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;
    //mapping of owner to list of all owner token ids
    mapping(address => uint256[]) private _ownedTokens;
    //mapping from tokenId to index of the owner tokens list
    mapping(uint => uint256) private _ownedTokensIndex;


    function _mint(address to, uint256 tokenId) internal override(ERC721){
        super._mint(to, tokenId);

        _addTokensToAllTokenEnumeration(tokenId);  
        _addTokensToOwnerEnumeration(to, tokenId);   
    }

// add tokens to the _alltokens array and set the position of the tokens indexes
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _addTokensToOwnerEnumeration(address to,uint256 tokenId) private{
        //1. add address and token id to the _ownedTokens
        //2. ownedTokensIndex tokenId set to address of ownedTokens position
        //3. we want to execute the function with minting
        _ownedTokens[to].push(tokenId);
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length; 
    }
 
    //two functions - one that returns tokenByIndex and
    // another one that returns tokenOfOwnerByIndex

    function tokenByIndex(uint index) public view returns(uint256){
        //make sure that the index is not out of bound of the total supply
        require(index < totalSupply(),'global index is out of bound');
        return _allTokens[index];
    }

    function tokenOfOwnerByIndex(address owner, uint index) public view returns(uint256){
        require(index < balanceOf(owner),'owner index is out of bound');
        return _ownedTokens[owner][index];

    }

// return the total supply of the _allTokens array
    function totalSupply() public view returns(uint256){
        return _allTokens.length;
    }
}