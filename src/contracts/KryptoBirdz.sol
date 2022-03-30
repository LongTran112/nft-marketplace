// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './ERC721Connector.sol';
contract Kryptobird is ERC721Connector{
    // string public name;
    // string public symbol;

    // constructor(){
    //     name = 'Kryptobird';
    //     symbol = 'KBIRDZ';
    // }


    //array to store our nfts
    string [] public KryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public{
        require(!_kryptoBirdzExists[_kryptoBird],
        'Error - kryptoBirdz already exists');

        // this is deprecated
        //.push no longer returns the length but a ref to the added element
        // uint _id = KryptoBirdz.push(_kryptoBird);

        KryptoBirdz.push(_kryptoBird);
        uint _id = KryptoBirdz.length - 1;

        _mint(msg.sender, _id);

        _kryptoBirdzExists[_kryptoBird] = true;

    }


    constructor() ERC721Connector('KryptoBird','KBIRDZ'){}
}

