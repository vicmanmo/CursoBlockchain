// SPDX-License-Identifier: Apache 2.0

pragma solidity >0.8.14;

contract AmbulanceTransfer {

    address payable public ambulance;
    address public hospital;
    address public user;

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
    event NewValue(string message, address hospital);

    constructor(address _userIni, address _hospitalIni, bool _aliveIni, bool _consciousIni, uint64 _distanceMIni ) {
        ambulance = payable(msg.sender);
        startDate = block.timestamp;
        payment = 1 ether;
        arrival = false;  
        pressure = Pressure(0,0);      

        user = _userIni;
        hospital = _hospitalIni;
        alive = _aliveIni;        
        conscious = _consciousIni;
        distanceM = _distanceMIni;
    }

    modifier isAuthorised(){
        require(msg.sender == ambulance && !arrival);
        _;
    }

    function updateHeartRate( uint8 _heartRate) isAuthorised() public{      
        
        heartRate = _heartRate;       

        emit NewValue("Update value Heart Rate.", hospital);
    }

    function getHeartRate() public view returns(uint8){
        return heartRate;
    }

    function updateDistance( uint64 _distanceM ) isAuthorised() public{
        distanceM = _distanceM;

        emit NewValue("Update value Distance.", hospital);
    }

    function getDistance() public view returns(uint64){
        return distanceM;
    }


    function updatePressure( uint8 _high, uint8 _low ) isAuthorised() public{
        pressure.high = _high;
        pressure.low = _low;

        emit NewValue("Update value Pressure.", hospital);
    }

    function getPressure() public view returns(uint8 , uint8){
        return (pressure.high,pressure.low);
    }

    function updateAlive( bool _alive ) isAuthorised() public{
        alive = _alive;

        emit NewValue("Update value Alive.", hospital);
    }

    function getAlive() public view returns(bool){
        return alive;
    }

    function updateConscious( bool _conscious ) isAuthorised() public{
        conscious = _conscious;

        emit NewValue("Update value Conscious.", hospital);
    }

    function getConscious() public view returns(bool){
        return conscious;
    }

    // Funciones de pánico/emergencia
    function stopAmbulanceTransfer() isAuthorised() public { 
        arrival = true;
        //Envia el dinero del usuario a la ambulancia
        ambulance.transfer(payment);

        emit Status("El paciente ha llegado al hospital");
    }

    function getArrival() public view returns(bool){
        return arrival;
    }




        








}