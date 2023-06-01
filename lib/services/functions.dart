import 'package:flutter/services.dart';
import 'package:not_a_taxi/utils/globals.dart';
import '/utils/constants.dart';
import 'package:web3dart/web3dart.dart';

Future<DeployedContract> loadContract() async {
  String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Carpooling'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args, Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

Future<String> createRide(String origin, String destination, String departureDate, String departureTime,
    String passengerLimit, String carId, Web3Client ethClient)
        async {
          var response = 
          await callFunction('createRide', [origin, destination, departureDate, 
              departureTime, passengerLimit, carId], ethClient, owner_private_key);
        print("Ride Created Succesfully! (pushed into BlockChain)");
        return response;
        }

Future<String> bookRide(String passengerID,  String driverID, String origin, 
String dropOff, String destination, String departureDate, String departureTime,
    String fare, Web3Client ethClient)
        async {
          var response = 
          await callFunction('bookRide', [passengerID, driverID, origin, dropOff, destination, departureDate, 
              departureTime, fare], ethClient, owner_private_key);
        print("Ride Booked Succesfully! (pushed into BlockChain)");
        return response;
        }

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result = ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<List> getRidesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getRidesNum', [], ethClient);
  print("Hello");
  print(result);
  return result;
}

Future<List> getRide(int index, Web3Client ethClient) async {
  print("Index = $index");
  List<dynamic> result =
      await ask('getRide', [BigInt.from(index)], ethClient);
  return result;
}
Future<List> getBookedRidesNum(Web3Client ethClient) async {
  List<dynamic> result = await ask('getBookedRidesNum', [], ethClient);
  print("hELLO");
  print(result);
  return result;
}

Future<List> getBookedRide(int index, Web3Client ethClient) async {
  print(index);
  List<dynamic> result =
      await ask('getBookedRide', [BigInt.from(index)], ethClient);
  return result;
}


