import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class MapEvent {}

class LoadCurrentLocationEvent extends MapEvent {}

class UpdateMapLocationEvent extends MapEvent {
  final LatLng latLng;

  UpdateMapLocationEvent(this.latLng);
}
class LoadSelectedLocationEvent extends MapEvent {
  final LatLng latLng;

  LoadSelectedLocationEvent(this.latLng);


  List<Object?> get props => [latLng];
}