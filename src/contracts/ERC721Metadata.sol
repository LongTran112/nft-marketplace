// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './interfaces/IERC721Metadata.sol';

contract ERC721Metadata is IERC721Metadata{

    string private _name;
    string private _symbol;

    constructor(string memory named, string memory symboled){
        _name = named;
        _symbol = symboled;
    }

    function name() external view override returns(string memory){
        return _name;
    }

    function symbol() external view override returns(string memory){
        return _symbol;
    }

}