// ignore_for_file: must_be_immutable
import 'dart:developer';

import 'package:auto_route/auto_route.dart';
import 'package:e_comm_user/bloc/address/address_bloc.dart';
import 'package:e_comm_user/bloc/address/address_event.dart';
import 'package:e_comm_user/bloc/address/address_state.dart';
import 'package:e_comm_user/bloc/order/order_bloc.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/address_request_model.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/constants.dart';
import 'package:e_comm_user/utils/functions.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_alert.dart';
import 'package:e_comm_user/widgets/custom_appbar.dart';
import 'package:e_comm_user/widgets/custom_button.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

@RoutePage()
class AddressListScreen extends StatefulWidget {
    AddressListScreen({super.key,this.isFrom = '',this.orderId});
  String? isFrom;
  int? orderId;

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  AddressBloc addressBloc = getIt.get<AddressBloc>();
  OrderBloc orderBloc = getIt.get<OrderBloc>();


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
       child: Scaffold(
        appBar: CustomAppBar(
          title: address,
          onBackPressed: () async {
            await Future.delayed(const Duration(milliseconds: 200));
            addressBloc.add(AddressListEvent());
            getIt<AppRoutes>().pop(true);
          },
          action: IconButton(onPressed: () async {
            final result = await getIt<AppRoutes>().push(CreateAddressRoute());
            if (result == true) {
              addressBloc.add(AddressListEvent());
            }
          }, icon: Icon(Icons.add)),
        ),
        backgroundColor: whiteColor,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: BlocProvider.value(
            value: addressBloc..add(AddressListEvent()),
            child: BlocListener<AddressBloc, AddressState>(
              listener: (context, state) async {
                if(state is AddressActionSuccessState){
                  Functions.showCustomSnackBar(context, message: state.message,backgroundColor: successColor);
                  await Future.delayed(const Duration(milliseconds: 200));
                  addressBloc.add(AddressListEvent());
                  getIt<AppRoutes>().pop(true);
                }
                else if(state is AddressErrorState){
                  Functions.showCustomSnackBar(context, message: state.error,backgroundColor: errorColor);
                }
              },
            child: BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  if(state is AddressLoadingState){
                    return const Center(child: CircularProgressIndicator());
                  }
                  else if (state is AddressSuccessState){
                    addressResponseModel = state.addressResponseModel;
                    return addressResponseModel.data!.isEmpty  ?
                    Center(child: CustomText(text: noAddressFound))
                        :
                    Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            // itemCount: (addressResponseModel.data?.length ?? 0) + 1, // if address button last of list
                            itemCount: addressResponseModel.data?.length ?? 0 ,
                            itemBuilder: (context, index) {
                              // if address button last of list
                              /*if (index == addressResponseModel.data!.length) {
                                    return CustomButton(
                                      text: addNewAddress,
                                      onPressed: () {
                                          getIt<AppRoutes>().push(CreateAddressRoute());
                                      },
                                    );
                                  }*/

                              final addressData = addressResponseModel.data![index] ;
                              final isSelected = addressData.id == state.selectedAddressId;
                              return GestureDetector(
                                onTap: () {
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 1.h),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.5.w, vertical: 2.h),
                                  decoration: BoxDecoration(
                                    color: whiteColor,
                                    borderRadius: BorderRadius.circular(1.h),
                                    border: Border.all(
                                        color: greyColor.withValues(alpha: .3)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on_outlined,
                                                  color: greyColor.withValues(alpha: .6),
                                                ),
                                                SizedBox(width: 1.w),
                                                Expanded(
                                                  child: CustomText(
                                                    text: addressData.full_name ?? '',
                                                    fontSize: 15.px,
                                                    style: CustomTextStyle.bold,
                                                    maxLines: 5,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (addressData.is_default ?? false) ...[
                                                  SizedBox(width:2.w),
                                                  Container(
                                                    padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: greyColor.withValues(alpha: .2),
                                                      borderRadius: BorderRadius.circular(1.h),
                                                    ),
                                                    child:
                                                    CustomText(text: 'Default'),
                                                  ),
                                                ]
                                              ],
                                            ),
                                            SizedBox(height: 1.h),
                                            CustomText(
                                              text:
                                              "${addressData.address_line ?? ''}, "
                                                  "${addressData.city ?? ''}, "
                                                  "${addressData.state ?? ''}, "
                                                  "${addressData.country ?? ''} - "
                                                  "${addressData.pincode ?? ''}",
                                              fontSize: 14.px,
                                              color: greyColor.withValues(alpha: .6),
                                              maxLines: 5,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            CustomText(
                                              text: addressData.phone ?? '',
                                              fontSize: 13.px,
                                              style: CustomTextStyle.medium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 1.w),
                                      Container(
                                        transform: Matrix4.translationValues(4.w, 0, 0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                addressBloc.add(AddressSelectEvent(addressData.id!));
                                              },
                                              icon: Icon(
                                                isSelected
                                                    ? Icons.check_circle
                                                    : Icons.radio_button_unchecked,
                                                color: isSelected
                                                    ? Colors.green
                                                    : greyColor.withValues(alpha: .6),
                                              ),
                                            ),
                                            PopupMenuButton<String>(
                                              borderRadius: BorderRadius.circular(1.h),
                                              color: whiteColor,
                                              icon: Icon(
                                                Icons.more_vert,
                                                color: greyColor.withValues(alpha: .5),
                                              ),
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  final result = await getIt<AppRoutes>().push(CreateAddressRoute(addressData: addressData));

                                                  if (result == true) {
                                                    addressBloc.add(AddressListEvent());
                                                  }
                                                }

                                                if (value == 'delete') {
                                                  // TODO: Delete action
                                                  // context.read<AddressBloc>().add(DeleteAddressEvent(id));
                                                  final shouldLogout = await CustomPopupDialog.show(
                                                    context,
                                                    title: deleteAddress,
                                                    description: sureDeleteAddress,
                                                    positiveButtonText: delete,
                                                    negativeButtonText: cancel,
                                                    icon: Container(
                                                      height: 70,
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                        color: errorColor.withValues(alpha: .1),
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: errorColor,
                                                        size: 35,
                                                      ),
                                                    ),
                                                  );
                                                  if (shouldLogout == true) {
                                                    addressBloc.add(AddressDeleteEvent(addressData.id ?? 0));
                                                  }
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 'edit',
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.edit, size: 18),
                                                      SizedBox(width: 10),
                                                      Text("Edit"),
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 'delete',
                                                  child: Row(
                                                    children: const [
                                                      Icon(Icons.delete, size: 18, color: Colors.red),
                                                      SizedBox(width: 10),
                                                      Text("Delete"),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Visibility(
                          // visible: (state.addressResponseModel.data?.length ?? 0)> 1,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomButton(
                              text: widget.isFrom == orderDetails ? updateAddress : deliverHere,
                              onPressed: () {
                                final selectedAddressId = state.selectedAddressId;

                                /// already default
                                final selectedAddress =
                                addressResponseModel.data?.firstWhere(
                                      (e) => e.id == selectedAddressId,
                                );

                                // if (selectedAddress?.is_default == true) {
                                //   Functions.showCustomSnackBar(context, message: alreadyDefaultAddress);
                                //   return;
                                // }
                                // if(widget.isFrom == orderDetails){
                                //   addressRequestModel = AddressRequestModel(is_default: true);
                                //   addressBloc.add(UpdateOrderAddressEvent(widget.orderId ?? 0,selectedAddressId,addressRequestModel));
                                //   orderBloc.add(OrderDetailsEvent(widget.orderId ?? 0));
                                // }
                                // else{
                                  addressRequestModel = AddressRequestModel(is_default: true);
                                  addressBloc.add(UpdateAddressEvent(selectedAddressId,addressRequestModel),);
                                // }
                              },
                            ),
                          ),
                        )
                      ],
                    );
                  }
                  else if (state is AddressErrorState){
                    return Center(child: CustomText(text: state.error,));
                  }
                  return SizedBox();
                }
            ),
      ),
          ),
        ),
      ),
    );
  }
}