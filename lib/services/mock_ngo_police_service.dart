import '../models/ngo_model.dart';
import '../models/police_model.dart';

class MockNgoPoliceService {
  static final MockNgoPoliceService _instance = MockNgoPoliceService._internal();
  factory MockNgoPoliceService() => _instance;

  MockNgoPoliceService._internal();

  List<NgoModel> getNgos() => [
    NgoModel(
      id: '1',
      name: 'Women Safety NGO',
      phone: '+91 1800 123 4567',
      address: '123 Safety Street, Bangalore',
      distanceKm: 2.5,
    ),
    NgoModel(
      id: '2',
      name: 'Crisis Support Center',
      phone: '+91 1800 765 4321',
      address: '456 Help Avenue, Bangalore',
      distanceKm: 4.2,
    ),
    NgoModel(
      id: '3',
      name: 'Sakhi Foundation',
      phone: '+91 98765 00000',
      address: '789 Support Road, Bangalore',
      distanceKm: 5.8,
    ),
  ];

  List<PoliceStationModel> getPoliceStations() => [
    PoliceStationModel(
      id: '1',
      name: 'Central Police Station',
      phone: '+91 100',
      address: '1 Police Circle, Bangalore',
      distanceKm: 1.2,
    ),
    PoliceStationModel(
      id: '2',
      name: 'Women Help Desk',
      phone: '+91 100',
      address: '50 Safety Complex, Bangalore',
      distanceKm: 3.5,
    ),
    PoliceStationModel(
      id: '3',
      name: 'Local Police Station',
      phone: '+91 100',
      address: '100 Station Road, Bangalore',
      distanceKm: 2.8,
    ),
  ];
}
