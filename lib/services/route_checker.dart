checkPassengerRide(
    String driverStartingPoint,
    String driverDestination,
    String passengerStartingPoint,
    String passengerDestination,
    ) {
      print(driverStartingPoint);
      print(passengerStartingPoint);

      if(driverStartingPoint == passengerStartingPoint) {
        return true;
      }
      return false;
    }