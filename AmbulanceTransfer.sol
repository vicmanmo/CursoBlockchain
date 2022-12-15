// SPDX-License-Identifier: Apache 2.0

pragma solidity >0.8.14;

// Informacion del Smart Contract
// Nombre: Translado en Ambulancia
// Logica: Implementa el translado de ambulancia de un paciente desde un lugar al hospital
// Con varios parámetros cargados mediante IoT o GPS
// Pagp por el servicio

// Declaracion del Smart Contract - AbulanceTransfer
contract AmbulanceTransfer {
    //Dirección de la ambulancia
    address payable public ambulance;
    //Dirección del hospital
    address public hospital;
    //Dirección del paciente
    address payable public user;
    
    //pago por el servicio
    uint256 public payment;

    //Parámetros del paciente
    //Está vivo?
    bool private alive;
    //Está consciente?
    bool private conscious;
    //Presión sanguínea del paciente IoT
    struct Pressure {
        uint8 high;
        uint8 low;
    }
    Pressure private pressure;
    //Ritmo cardiaco del paciente IoT
    uint8 private heartRate;
    //Distancia en metros desde la ambulacia hasta el hospital GPS
    uint32 private distanceM;

    //Ha llegado al hospital?
    bool private arrival;

    //Estado del contrato
    bool private activeContract;

    // ----------- Eventos (pueden ser emitidos por el Smart Contract) -----------
    event Status(string message);
    event NewValue(string message, address hospital);

    // ----------- Constructor -----------
    // Uso: Inicializa el Smart Contract, parámetros de direcciones de la ambulancia y del hospital de destino
    constructor(address _ambulanceIni, address _hospitalIni) payable {
        //Pago mínimo de usuario por el servicio de ambulancia
        uint256 _payment = 10000000 gwei; //0.01 ether

        user = payable(msg.sender);
        // Actualiza el payment
        payment = msg.value;

        if (payment >= _payment) {
            ambulance = payable(_ambulanceIni);
            hospital = _hospitalIni;           
            
            //activamos el contrato
            activeContract = true;

            alive = true;
            conscious = true;
            distanceM = 0;
            arrival = false;
            pressure = Pressure(0, 0);

            // Se emite un evento
            emit Status("Payment made we perform ambulance service.");
        } else {
            //Desactivamos el contrato
            activeContract = false;
            //Se devuelve el dinero al usuario
            user.transfer(payment);
            // Se emite un evento
            emit Status("The payment is not enough to perform the service. MIN: 0.01 ether");
            //revert("The payment is not enough to perform the service. MIN: 0.01 ether");
        }        
    }

    // Declaración de los modificadores

    // La autorización de la ambulancia
    modifier isAmbulance() {
        require(
            activeContract && msg.sender == ambulance && !arrival,
            "You aren't authorised."
        );
        _;
    }

    //La autorización del hospital
    modifier isHospital() {
        require(
            activeContract && msg.sender == hospital,
            "You aren't authorised."
        );
        _;
    }

    // ------------ Funciones que modifican datos (set) ------------

    // Funcion
    // Nombre: updateHeartRate
    // Uso:    Permite a la ambulancia actualizar el ritmo cardiaco del paciente
    function updateHeartRate(uint8 _heartRate) public isAmbulance {
        heartRate = _heartRate;
        emit NewValue("Update value Heart Rate.", hospital);
    }

    // Funcion
    // Nombre: updateDistance
    // Uso:    Permite a la ambulancia actualizar la distancia que queda hasta el hospital
    function updateDistance(uint32 _distanceM) public isAmbulance {
        distanceM = _distanceM;
        emit NewValue("Update value Distance.", hospital);
    }

    // Funcion
    // Nombre: updatePressure
    // Uso:    Permite a la ambulancia actualizar la presión arterial del paciente
    function updatePressure(uint8 _high, uint8 _low) public isAmbulance {
        pressure.high = _high;
        pressure.low = _low;
        emit NewValue("Update value Pressure.", hospital);
    }

    // Funcion
    // Nombre: updateAlive
    // Uso:    Permite a la ambulancia actualizar el estado del paciente, si está vivo o no
    function updateAlive(bool _alive) public isAmbulance {
        alive = _alive;
        emit NewValue("Update value Alive.", hospital);
    }

    // Funcion
    // Nombre: updateConscious
    // Uso:    Permite a la ambulancia actualizar el estado del paciente, si está consciente o no
    function updateConscious(bool _conscious) public isAmbulance {
        conscious = _conscious;
        emit NewValue("Update value Conscious.", hospital);
    }

    // Funcion
    // Nombre: setArrival
    // Uso:    Permite a la ambulancia actualizar el estado la llegada al hospital, finalizar el contrato
    //          y que se le efectúe el pago del servicio realizado.
    function setArrival() public payable isAmbulance {
        require(activeContract, "The smart contract is not active.");
        distanceM = 0;
        arrival = true;
        activeContract = false;
        ambulance.transfer(payment);
        emit NewValue("Llegada de la ambulancia.", hospital);
    }

    // ------------ Funciones de panico/emergencia ------------

    // Funcion
    // Nombre: stopAmbulanceTransfer
    // Uso:    Para el contrato .
    function stopAmbulanceTransfer() public payable {
        require(msg.sender == user, "You must be the owner");
        activeContract = false;
        //Envia el dinero de vuelva al usuario
        user.transfer(payment);
        emit Status("Cancel transfer ambulance.");
    }

    // ------------ Funciones que consultan datos (get) ------------

    // Funcion
    // Nombre: getHeartRate
    // Logica: Consulta el ritmo cardiaco del paciente al hospital
    function getHeartRate() public view isHospital returns (uint8) {
        return heartRate;
    }

    // Funcion
    // Nombre: getDistance
    // Logica: Consulta la distancia hasta el hospital de la ambulancia y solo al hospital
    function getDistance() public view isHospital returns (uint32) {
        return distanceM;
    }

    // Funcion
    // Nombre: getPressure
    // Logica: Consulta el presión arterial del paciente al hospital
    function getPressure() public view isHospital returns (uint8, uint8) {
        return (pressure.high, pressure.low);
    }

    // Funcion
    // Nombre: getAlive
    // Logica: Consulta si está vivo el paciente al hospital
    function getAlive() public view isHospital returns (bool) {
        return alive;
    }

    // Funcion
    // Nombre: getConscious
    // Logica: Consulta si está consciente el paciente al hospital
    function getConscious() public view isHospital returns (bool) {
        return conscious;
    }

    // Funcion
    // Nombre: isArrival
    // Logica: Consulta si ha llegado la ambulancia al hospital
    function isArrival() public view isHospital returns (bool) {
        return arrival;
    }

    // Funcion
    // Nombre: isActive
    // Logica: Consulta si el contrato está activo o no
    function isActive() public view returns (bool) {
        return (activeContract);
    }
}
