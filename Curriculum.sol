// SPDX-License-Identifier: Apache 2.0

pragma solidity >0.8.14;

contract Curriculum {

    address isOwner;

    constructor() {
        isOwner = msg.sender;
    }

}