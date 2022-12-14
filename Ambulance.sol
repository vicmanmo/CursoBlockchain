// SPDX-License-Identifier: Apache 2.0

pragma solidity >0.8.14;

contract Ambulance {

    address public ambulance;
    address public hospital;
    address public patient;

    //payment patient
    uint256 private payment;     
    
    uint256 public startDate;
    bool private alive;
    bool private conscious;
    //blood pressure patient IoT
    struct Pressure{uint8 high; uint8 low;}  
    Pressure private pressure;
    //distance from ambulance to hospital in meters
    uint64 private distanceM;
    //heartRate patient IoT  
    uint8 private heartRate;     

    //arrival at the hospital
    bool private arrival; 

    event Status(string message);

    constructor(address _patientIni, address _hospitalIni, bool _aliveIni, bool _consciousIni, uint64 _distanceMIni ) {
        ambulance = msg.sender;
        startDate = block.timestamp;
        payment = 1 ether;
        arrival = false;  
        pressure = Pressure(0,0);      

        patient = _patientIni;
        hospital = _hospitalIni;
        alive = _aliveIni;        
        conscious = _consciousIni;
        distanceM = _distanceMIni;
    }

    modifier isAuthorised(){
        require(msg.sender == ambulance);
        _;
    }

    function updateValues( uint64 _distanceM, uint8 _heartRate, uint8 _high, uint8 _low ) isAuthorised() public{
       
        distanceM = _distanceM;
        heartRate = _heartRate;

        pressure.high = _high;
        pressure.low = _low;

        emit Status("Update values.");
    }




        








}