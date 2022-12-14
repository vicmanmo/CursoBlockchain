// SPDX-License-Identifier: Apache 2.0

pragma solidity >0.8.14;

contract Ambulance {

    address public ambulance;
    address public hospital;
    address public patient;

    int256 private payment;
    
    bool private alive;
    bool private conscious;
    struct pressure{int8 high; int8 low;}
    int64 private distanceM;
    int8 private heartRate;

    constructor(address patientIni, address hospitalIni, bool aliveIni, bool consciousIni, int64 distanceMIni ) {
        ambulance = msg.sender;
        patient = patientIni;
        hospital = hospitalIni;
        payment = 1 ether;
        alive = aliveIni;
        conscious = consciousIni;
        distanceM = distanceMIni;
    }


    

}