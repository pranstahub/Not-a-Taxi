// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Carpooling {
    struct Ride {
        //uint rideId;
        string origin;
        string destination;
        string date;
        string departureTime;
        string passengerLimit;
        string carId;
    }

    struct bookedRide {
        //uint bookID;
        string passengerID;
        string driverID;
        string origin;
        string dropOff;
        string destination;
        string date;
        string departureTime;
        string fare;
    }
    //mapping (uint => address) public rideOwner;
    //mapping (uint => mapping(uint => address)) public rideToRider;
    //uint8 public rideCount = 0;
    Ride[] public rides;
    bookedRide[] public booked;

    event RideCreated(
        //uint rideId,
        string origin,
        string destination,
        string date,
        string departureTime,
        string passengerLimit,
        string carId
    );
    
    event RideBooked(
        string passengerID,
        string driverID,
        string origin,
        string dropOff,
        string destination,
        string date,
        string departureTime,
        string fare
    );

    function createRide(string memory _origin, 
            string memory _destination, 
            string memory _date,
            string memory _departureTime, 
            string memory _passengerLimit,
            string memory _carId) public {
        rides.push(Ride( _origin, _destination, _date, _departureTime, _passengerLimit, _carId));
  
        emit RideCreated(_origin, _destination, _date, _departureTime, _passengerLimit, _carId);
     
    }  

    function getRidesNum() public view returns (uint){
        return rides.length;
    }

    function getRide(uint index) public view returns(Ride memory) {
        return rides[index];
    }

    function bookRide(
        string memory _passengerID, 
        string memory _driverID,
            string memory _origin,
            string memory _dropOff, 
            string memory _destination, 
            string memory _date,
            string memory _departureTime, 
            string memory _fare) public {
        booked.push(bookedRide(_passengerID ,_driverID,_origin, _dropOff, 
             _destination, _date, _departureTime, 
             _fare));

        emit RideBooked( _passengerID, _driverID, 
            _origin, _dropOff, _destination, _date, 
            _departureTime, _fare);
    }  

    function getBookedRidesNum() public view returns (uint){
        return booked.length;
    }
    function getBookedRide(uint index) public view returns(bookedRide memory) {
        return booked[index];
    }
   
}
