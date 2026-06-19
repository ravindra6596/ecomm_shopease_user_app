import 'dart:async';

import 'package:auto_route/annotations.dart';
import 'package:e_comm_user/bloc/address/address_bloc.dart';
import 'package:e_comm_user/bloc/address/address_event.dart';
import 'package:e_comm_user/bloc/address/address_state.dart';
import 'package:e_comm_user/bloc/home/home_bloc.dart';
import 'package:e_comm_user/bloc/home/home_event.dart';
import 'package:e_comm_user/bloc/map/map_bloc.dart';
import 'package:e_comm_user/bloc/map/map_event.dart';
import 'package:e_comm_user/bloc/map/map_state.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/address_request_model.dart';
import 'package:e_comm_user/models/address_response_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:e_comm_user/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

@RoutePage()
class CreateAddressScreen extends StatefulWidget {
  const CreateAddressScreen({super.key,this.addressData});
  final AddressData? addressData;
  @override
  State<CreateAddressScreen> createState() => _CreateAddressScreenState();
}

class _CreateAddressScreenState extends State<CreateAddressScreen> {
  var fullNameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var countryController = TextEditingController();
  var pinCodeController = TextEditingController();
  var searchController = TextEditingController();
  AddressBloc addressBloc = getIt<AddressBloc>();
  final Completer<GoogleMapController> mapController = Completer();
  MapBloc mapBloc = getIt<MapBloc>();
  HomeBloc homeBloc =getIt<HomeBloc>();
  LatLng selectedLatLng = const LatLng(20.5937, 78.9629);
  bool isAddressInitialized = false;
  bool isMapInitialized = false;
  GoogleMapController? googleMapController;
  Timer? _debounce;
  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();

    /// UPDATE MODE
    if (widget.addressData != null) {
      fullNameController.text =  widget.addressData?.full_name ?? '';
      phoneController.text = widget.addressData?.phone ?? '';
      addressController.text = widget.addressData?.address_line ?? '';
      cityController.text = widget.addressData?.city ?? '';
      stateController.text = widget.addressData?.state ?? '';
      countryController.text = widget.addressData?.country ?? '';
      pinCodeController.text = widget.addressData?.pincode ?? '';
      selectedLatLng = LatLng(
        widget.addressData?.latitude ?? 20.5937,
        widget.addressData?.longitude ?? 78.9629,
      );
      mapBloc.add(
        LoadSelectedLocationEvent(selectedLatLng),
      );
    }
    else{
    mapBloc.add(LoadCurrentLocationEvent());
    }
  }
  @override
  void dispose() {
    _debounce?.cancel();

    fullNameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    pinCodeController.dispose();
    googleMapController?.dispose();
    super.dispose();
  }
  setUpdatedAddress(String newAddress) async {
    final prefs = await SharedPreferences.getInstance();
    final address = prefs.setString(SharedPrefHelper.userAddress,newAddress) ?? "";
    addressStreamController.add(newAddress);
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => addressBloc,
      child: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
            if(state is AddressActionSuccessState){
              Functions.showCustomSnackBar(context, message: state.message,backgroundColor: successColor);
              homeBloc.add(GetHomeEvent(0));
              getIt<AppRoutes>().pop(true);
            }
            else if(state is AddressErrorState){
              Functions.showCustomSnackBar(context, message: state.error,backgroundColor: errorColor);
            }
        },
        child: Scaffold(
          backgroundColor: whiteColor,
          appBar: CustomAppBar(
            title: widget.addressData == null
                ? createAddress
                : updateAddress,

          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: Form(
              key: formKey,
              child: Column(
                spacing: 2.h,
                children: [
                  Visibility(
                    visible: false,
                    child: GooglePlaceAutoCompleteTextField(
                      textEditingController: searchController,
                      googleAPIKey: '',
                      inputDecoration: InputDecoration(
                        hintText: "Search address",
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                      ),

                      debounceTime: 600,
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (prediction) async {
                        final lat = double.parse(prediction.lat!);
                        final lng = double.parse(prediction.lng!);
                        selectedLatLng = LatLng(lat, lng);
                        googleMapController?.animateCamera(
                          CameraUpdate.newLatLngZoom(
                            selectedLatLng,
                            16,
                          ),
                        );
                        mapBloc.add(
                          UpdateMapLocationEvent(selectedLatLng),
                        );
                      },
                      itemClick: (prediction) {
                        searchController.text = prediction.description ?? '';
                      },
                    ),
                  ),
                  SizedBox(
                    height: 40.h,
                    child: BlocBuilder<MapBloc, MapState>(
                      bloc: mapBloc,
                      builder: (context, state) {

                        if (state is MapLoadingState) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state is MapLoadedState) {

                          selectedLatLng = state.position ?? selectedLatLng;

                          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                            /// EDIT MODE
                            if (widget.addressData != null && !isAddressInitialized) {
                              isAddressInitialized = true;
                              addressController.text = widget.addressData?.address_line ?? '';
                              cityController.text = widget.addressData?.city ?? '';
                              stateController.text = widget.addressData?.state ?? '';
                              countryController.text = widget.addressData?.country ?? '';
                              pinCodeController.text = widget.addressData?.pincode ?? '';
                              return;
                            }
                            // if (widget.addressData == null) {
                              addressController.text = state.address ?? '';
                              cityController.text = state.city ?? '';
                              stateController.text = state.state ?? '';
                              countryController.text = state.country ?? '';
                              pinCodeController.text = state.pincode ?? '';
                              // isAddressInitialized = true;
                            // }
                          },);

                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              GoogleMap(
                                initialCameraPosition: CameraPosition(
                                  target: selectedLatLng,
                                  zoom: 16,
                                ),
                                myLocationEnabled: true,
                                myLocationButtonEnabled: true,
                                zoomControlsEnabled: false,
                                zoomGesturesEnabled: true,
                                scrollGesturesEnabled: true,
                                rotateGesturesEnabled: true,
                                tiltGesturesEnabled: true,
                                onMapCreated: (controller) async {
                                  googleMapController = controller;
                                  if (!isMapInitialized) {
                                    isMapInitialized = true;
                                    final initialPos = state.position ?? selectedLatLng;
                                    selectedLatLng = initialPos;
                                    await controller.animateCamera(
                                      CameraUpdate.newLatLngZoom(
                                        initialPos,
                                        16,
                                      ),
                                    );
                                  }
                                },
                                onCameraMove: (position) {
                                  selectedLatLng = position.target;
                                },
                                onCameraIdle: () {
                                  _debounce?.cancel();
                                  _debounce = Timer(
                                    const Duration(milliseconds: 500),
                                        () {
                                      mapBloc.add(
                                        UpdateMapLocationEvent(
                                          selectedLatLng,
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              IgnorePointer(
                                child: Transform.translate(
                                  offset: const Offset(0, -18),
                                  child: Icon(
                                    Icons.location_pin,
                                    color: primaryColor,
                                    size: 45,
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: 10,
                                left: 10,
                                right: 10,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: CustomText(
                                    text: state.address ?? '',
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        if (state is MapErrorState) {
                          return Center(
                            child: CustomText(
                                text:state.error),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),
                  CustomTextField(
                    labelText: fullName,
                    hintText: enterYourFullName,
                    controller: fullNameController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return fullNameValidation;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),

                  CustomTextField(
                    labelText: phoneNumber,
                    hintText: enterYourPhoneNumber,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return phoneNumberValidation;
                      }
                      if (value.length < 10) {
                        return validPhoneNumberValidation;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),

                  CustomTextField(
                    labelText: addressLine,
                    hintText: enterAddress,
                    controller: addressController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return addressLineValidation;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),

                  CustomTextField(
                    labelText: city,
                    hintText: enterCity,
                    controller: cityController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return cityValidation;
                      }
                       return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),

                  CustomTextField(
                    labelText: state,
                    hintText: enterState,
                    controller: stateController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return stateValidation;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),

                  CustomTextField(
                    labelText: country,
                    hintText: enterCountry,
                    controller: countryController,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return countryValidation;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                  ),

                  CustomTextField(
                    labelText: pinCode,
                    hintText: enterPinCode,
                    controller: pinCodeController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return pinCodeValidation;
                      }
                      if (value.length < 6) {
                        return validPinCodeValidation;
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 4.h),
            child: CustomButton(
              text: widget.addressData == null ? saveAddress : updateAddress,
              onPressed: () {
                if (!formKey.currentState!.validate()) {
                  return;
                }
                addressRequestModel = AddressRequestModel(
                  full_name: fullNameController.text,
                  phone: phoneController.text,
                  address_line: addressController.text,
                  city: cityController.text,
                  state: stateController.text,
                  country: countryController.text,
                  pincode: pinCodeController.text,
                  address_type: 'Home',
                  latitude: selectedLatLng.latitude,
                  longitude: selectedLatLng.longitude,
                );
                final address = [ addressRequestModel.address_line, addressRequestModel.city,
                  addressRequestModel.state, addressRequestModel.country, addressRequestModel.pincode,
                ].where((e) => e != null && e.isNotEmpty).join(", ");
                if(widget.addressData == null){
                  addressBloc.add(CreateAddressEvent(addressRequestModel));
                  setUpdatedAddress(address);
                }else{
                  addressBloc.add(UpdateAddressEvent(widget.addressData?.id ?? 0,addressRequestModel));
                  setUpdatedAddress(address);
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}