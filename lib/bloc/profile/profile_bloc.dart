import 'package:e_comm_user/core/exception_handler.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/models/profile_response_model.dart';
import 'package:e_comm_user/repository/profile_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'profile_event.dart';
import 'profile_state.dart';


@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository? profileRepository;
  bool isEditing = false;
  ProfileBloc()
      : profileRepository = getIt<ProfileRepository>(),
        super(ProfileInitialState()) {
     
    on<LoadProfileEvent>(getProfileDetails);
    on<ToggleEditProfileEvent>(toggleEditProfile);
    on<UpdateProfileEvent>(updateProfile);
  }

 

  getProfileDetails(LoadProfileEvent event, emit) async {
    emit(ProfileLoadingState());
    final userDetails = await profileRepository!.getProfile();
    switch (userDetails) {
      case Success<ProfileResponseModel, Exception>():
        emit(ProfileSuccessState(userDetails.data,isEditing: isEditing,));
      case Failure<ProfileResponseModel, Exception>():
        emit(ProfileErrorState(userDetails.error));
    }
  }
  void toggleEditProfile(ToggleEditProfileEvent event, emit) {
    if (state is ProfileSuccessState) {
      final currentState = state as ProfileSuccessState;
      isEditing = !isEditing;
      emit(
        ProfileSuccessState(
          currentState.profileResponseModel,
          isEditing: isEditing,
        ),
      );
    }
  }

  Future<void> updateProfile(UpdateProfileEvent event,emit) async {

    emit(ProfileUpdatingState());
    final result = await profileRepository!.updateProfile(event.request);

    switch (result) {
      case Success<ProfileResponseModel, Exception>():

        isEditing = false;
        emit(ProfileUpdatedState(result.data.message ?? ''));
        emit(
          ProfileSuccessState(
            result.data,
            isEditing: false,
          ),
        );

      case Failure<ProfileResponseModel, Exception>():
        emit(ProfileErrorState(result.error.toString()));
    }
  }
}
