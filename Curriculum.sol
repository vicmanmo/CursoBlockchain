// SPDX-License-Identifier: Apache 2.0

pragma solidity >0.8.14;

contract Curriculum {

    address public isOwner;
    address public user;
    address public checker;
    string public hashCurriculum;
    bool public validated;
    struct dataCurriculum{string dato1; string data2;}

    constructor() {
        isOwner = msg.sender;
    }

}