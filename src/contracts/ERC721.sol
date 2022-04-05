// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC721.sol';
import './ERC165.sol';

    /*
    building out the minting function:
        a. nft to point to an address
        b. keep track of the token ids 
        c. keep track of token owner addresses to token ids
        d. keep track of how many tokens an owner address has
        e. create an event that emits a transfer log - contract address, 
         where it is being minted to, the id

    */

contract ERC721 is ERC165, IERC721{

    // event Transfer(
    //     address indexed from, 
    //     address indexed to, 
    //     uint indexed tokenId);
    // event Approval(
    //     address indexed owner,
    //     address indexed approved,
    //     uint256 indexed tokenId);
    

    // mapping in solidity creates a hash table of key pair values
   
    // Mapping from token id to the owner
    mapping(uint => address) private _tokenOwner;
    // Mapping from owner to number of owned tokens
    mapping(address => uint) private _ownedTokensCount;
    // Mappin from token id to approvec addresses
    mapping(uint => address) private _tokenApprovals;

    // 1.REGISTER THE INTERFACE FOR THE ERC721 so that it includes 
    // the following functions: balanceOf, ownerOf, transferFrom
    // *note by register the interface: write the constructors with the 
    // according byte conversions

    // 2. REGISTER THE INTERFACE FOR THE ERC721Enumerable contract so that it includes
    // totalSupply, tokenByIndex, tokenOfOwnerByindex functions

    // 3. REGISTER THE INTERFACE FOR THE ERC721Metadata contract so that includes 
    // name and the symbol functions
    
    constructor(){
        _registerInterface(bytes4(keccak256('balanceOf(bytes4)')^
        keccak256('ownerOf(bytes4)')^keccak256('transferFrom(bytes4)')));
    }


    function balanceOf(address _owner) public view returns(uint256){
        require(_owner != address(0),'owner query for non-existstent token');
        return _ownedTokensCount[_owner];
    }
    /// @notice Find the owner of an NFT
    /// @dev NFTs assigned to zero address are considered invalid, and queries
    ///  about them do throw.
    /// @param _tokenId The identifier for an NFT
    /// @return The address of the owner of the NFT

    function ownerOf(uint256 _tokenId) public view returns (address){
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

    /// @notice Transfer ownership of an NFT -- THE CALLER IS RESPONSIBLE
    ///  TO CONFIRM THAT `_to` IS CAPABLE OF RECEIVING NFTS OR ELSE
    ///  THEY MAY BE PERMANENTLY LOST
    /// @dev Throws unless `msg.sender` is the current owner, an authorized
    ///  operator, or the approved address for this NFT. Throws if `_from` is
    ///  not the current owner. Throws if `_to` is the zero address. Throws if
    ///  `_tokenId` is not a valid NFT.
    /// @param _from The current owner of the NFT
    /// @param _to The new owner
    /// @param _tokenId The NFT to transfer
    function _transferFrom(address _from, address _to, uint256 _tokenId) internal{
        require(_to != address(0), 'Error - ERC721 Transfer to the zeo address');
        require(ownerOf(_tokenId) == _from,'Trying to transfer a token the address does not own');

        _ownedTokensCount[_from] -= 1;
        _ownedTokensCount[_to] += 1;

        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) override public{
        require(isApprovedOrOwner(msg.sender, _tokenId));
        _transferFrom(_from, _to, _tokenId);
    }

    function approve(address _to, uint256 tokenId) public{
        address owner = ownerOf(tokenId);
        require(_to != owner,'Error - approval to current owner');
        require(msg.sender == owner, 'Current caller is not the owner of the token');
        _tokenApprovals[tokenId] = _to;

        emit Approval(owner, _to, tokenId);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool){
        require(_exists(tokenId), 'token does not exist');
        address owner= ownerOf(tokenId);
        return(spender == owner);
    }



    


}