import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

import 'map_event.dart';
import 'map_state.dart';

@injectable
class MapBloc extends Bloc<MapEvent, MapState> {

  MapBloc() : super(MapInitialState()) {

    on<LoadCurrentLocationEvent>(_loadCurrentLocation);
    on<UpdateMapLocationEvent>(_updateMapLocation);
    on<LoadSelectedLocationEvent>(_loadSelectedLocation);
  }

  Future<void> _loadCurrentLocation(LoadCurrentLocationEvent event,emit) async {
    try {
      emit(MapLoadingState());
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {

        emit(MapErrorState("Location permission denied"));
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      await _emitAddress(
        emit,
        LatLng(position.latitude, position.longitude),
      );

    } catch (e) {
      emit(MapErrorState(e.toString()));
    }
  }

  Future<void> _updateMapLocation(UpdateMapLocationEvent event,emit) async {
    await _emitAddress(emit, event.latLng);
  }
  Future<void> _loadSelectedLocation(
      LoadSelectedLocationEvent event,
      Emitter<MapState> emit,
      ) async {

    emit(MapLoadingState());

    try {

      final placemarks = await placemarkFromCoordinates(
        event.latLng.latitude,
        event.latLng.longitude,
      );

      final place = placemarks.first;
      emit(
        MapLoadedState(
          position: event.latLng,
          address: "${place.street}, ${place.locality}",
          city: place.locality,
          state: place.administrativeArea,
          country: place.country,
          pincode: place.postalCode,
        ),
      );

    } catch (e) {
      emit(MapErrorState(e.toString()));
    }
  }

  Future<void> _emitAddress(Emitter<MapState> emit,LatLng latLng) async {

    final placemarks = await placemarkFromCoordinates(
      latLng.latitude,
      latLng.longitude,
    );

    final place = placemarks.first;
    emit(
      MapLoadedState(
        position: latLng,
        address: "${place.street}, ${place.subLocality}",
        city: place.locality ?? "",
        state: place.administrativeArea ?? "",
        country: place.country ?? "",
        pincode: place.postalCode ?? "",
      ),
    );
  }
}