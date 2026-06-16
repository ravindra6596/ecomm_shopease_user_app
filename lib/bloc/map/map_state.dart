import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapState {}

class MapInitialState extends MapState {}

class MapLoadingState extends MapState {}

class MapLoadedState extends MapState {
  final LatLng? position;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;

  MapLoadedState({
    this.position,
    this.address,
    this.city,
    this.state,
    this.country,
    this.pincode,
  });
}

class MapErrorState extends MapState {
  final String error;

  MapErrorState(this.error);
}