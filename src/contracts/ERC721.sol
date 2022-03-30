// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
    /*
    building out the minting function:
        a. nft to point to an address
        b. keep track of the token ids 
        c. keep track of token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract address, 
         where it is being minted to, the id

    */

contract ERC721{

    event Transfer(
        address indexed from, 
        address indexed to, 
        uint indexed tokenId);

    // mapping in solidity creates a hash table of key pair values
   
    // Mapping from token id to the owner
    mapping(uint => address) private _tokenOwner;
    // Mapping from owner to number of owned tokens
    mapping(address => uint) private _ownedTokensCount;

/// @notice Count all NFTs assigned to an owner
    /// @dev NFTs assigned to the zero address are considered invalid, and this
    ///  function throws for queries about the zero address.
    /// @param _owner An address for whom to query the balance
    /// @return The number of NFTs owned by `_owner`, possibly zero

    function balanceOf(address _owner) public view returns(uint256){
        require(_owner != address(0),'owner query for non-existstent token');
        return _ownedTokensCount[_owner];
    }
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) external view returns (address){
        address owner = _tokenOwner[_tokenId];
        require(owner != address(0),'owner query for non-existstent token');
        return owner; 

    }



    function _exists(uint tokenId) internal view returns(bool){
        address owner = _tokenOwner[tokenId];
        return owner != address(0);
    }


    function _mint(address to, uint256 tokenId) internal virtual{
        //requires the address isn't zero
        require(to != address(0),'ERC721: minting to the zero address');
        //requires that the token does not already exist
        require(!_exists(tokenId),'ERC721: token already minted');
        //we are adding a new address with a token id for minting
        _tokenOwner[tokenId] = to;
        //keeping track of each address that is minting and adding one
        _ownedTokensCount[to] += 1;

        emit Transfer(address(0), to, tokenId);
    } 


}