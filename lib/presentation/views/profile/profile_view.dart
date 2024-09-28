import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/presentation/pages/home/base/base_page.dart';
import '../../_widgets/profile/update_password_widget.dart';
import '../../_widgets/profile/user_profile_widget.dart';
import '../../_widgets/profile/user_rooms_widget.dart';
import '../../cubits/profile/password_cubit.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/profile/rooms_cubit.dart';

// ProfileView : profile view page
class ProfileView extends StatefulWidget {
  // auth use cases
  final AuthUseCases authUseCases;

  // constructor
  const ProfileView({
    super.key,
    required this.authUseCases,
  });

  // invoke view state
  @override
  ProfileViewState createState() => ProfileViewState();
}

// Profile View State
class ProfileViewState extends State<ProfileView> {
  // attributes
  bool showRooms = false;
  bool showPasswords = false;
  bool isEditingUsername = false;
  // Timer refreshTimer
  Timer? _loadingTimer;
  bool _isLoadingForLong = false; // Flag to control refresh button visibility

  // text controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();


  // Start the loading timer when entering loading state
  void _startLoadingTimer() {
    _loadingTimer?.cancel(); // Cancel any existing timers
    _loadingTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _isLoadingForLong = true; // Show refresh button after 3 seconds
      });
    });
  }

  // Reset the loading timer and hide the button when loading finishes
  void _resetLoadingState() {
    _loadingTimer?.cancel();
    setState(() {
      _isLoadingForLong = false;
    });
  }

  // Refresh the whole page
  void _refreshPage() {
    context.read<ProfileCubit>().loadProfile(); // Call to refresh the user data
    context.read<RoomsCubit>().loadRooms(); // Call to refresh the room data
    _resetLoadingState(); // Reset the loading state
  }

  // show/hide passwords fields
  void togglePasswords() {
    setState(() {
      showPasswords = !showPasswords;
    });
  }

  // update username method using ProfileCubit
  void saveUsername() {
    context.read<ProfileCubit>().updateUsername(usernameController.text);
    setState(() {
      isEditingUsername = false;
    });
  }

  // update password method using PasswordCubit
  void updatePassword(String oldPassword, String newPassword) {
    context.read<PasswordCubit>().updatePassword(oldPassword, newPassword);
  }

  // main build
  @override
  Widget build(BuildContext context) {
    // declare profile and room cubits
    final profileCubit = context.read<ProfileCubit>();
    final roomCubit = context.read<RoomsCubit>();
    // if profile or room state is loading or error, then start loading timer
    if (profileCubit.state is ProfileLoading || roomCubit.state is RoomsLoading || profileCubit.state is ProfileError || roomCubit.state is RoomsError) {
      _startLoadingTimer();
    } else {
      _resetLoadingState();
    }

    return BasePage(
      showFooter: false,
      authUseCases: widget.authUseCases,
      child: Scaffold(
        body: RefreshIndicator(
          // on refresh load profile and rooms
          onRefresh: () async {
            context.read<ProfileCubit>().loadProfile();
            context.read<RoomsCubit>().loadRooms();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                // bloc listener to profile state using profile cubit
                BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) async {
                    // if profile is loaded, then display a message, if error display a red error message
                    if (state is ProfileLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      // load secure storage
                      const secureStorage = FlutterSecureStorage();
                      var oldUsername = await secureStorage.read(key: 'username');
                      // check if user username is the same as the one in the secure storage
                      if (state.user.username != oldUsername) {
                        secureStorage.write(key: 'username', value: state.user.username);
                      }
                      usernameController.clear();
                    }
                    if (state is ProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                      );
                    }
                  },
                  // show profile using bloc builder on profile state
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      // if profile loaded then display user logged in
                      if (state is ProfileLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ProfileLoaded) {
                        UserEntity user = state.user;
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Welcome back, ${user.username}!',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // call UserProfileWidget
                                UserProfileWidget(
                                  user: user,
                                  isEditingUsername: isEditingUsername,
                                  usernameController: usernameController,
                                  onEditPressed: () {
                                    setState(() {
                                      isEditingUsername = true;
                                    });
                                  },
                                  onSavePressed: saveUsername,
                                  onTogglePasswords: togglePasswords,
                                  showPasswords: showPasswords,
                                  oldPasswordController: oldPasswordController,
                                  newPasswordController: newPasswordController,
                                ),
                                // show/hide password depending on showPasswords
                                if (showPasswords)
                                  BlocListener<PasswordCubit, PasswordState>(
                                    listener: (context, state) {
                                      if (state is PasswordUpdated) {
                                        setState(() {
                                          user = user.setUpdatedAt(DateTime.now());
                                          context.read<ProfileCubit>().loadDynamically(user,state.message);

                                        });

                                        oldPasswordController.clear();
                                        newPasswordController.clear();
                                        togglePasswords();
                                      } else if (state is PasswordError) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                                        );
                                      }
                                    },
                                    child: UpdatePasswordWidget(
                                      showPasswords: showPasswords,
                                      oldPasswordController: oldPasswordController,
                                      newPasswordController: newPasswordController,
                                      onTogglePasswords: togglePasswords,
                                      onUpdatePassword: () => updatePassword(
                                        oldPasswordController.text,
                                        newPasswordController.text,
                                      ),
                                    ),
                                  ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
                // display rooms using bloc builder on rooms state
                BlocBuilder<RoomsCubit, RoomsState>(
                  builder: (context, state) {
                    if (state is RoomsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is RoomsError) {
                      return const Center(child: Text('An error occurred'));
                    } else if (state is RoomsLoaded) {
                      return UserRoomsWidget(
                        userRoomNotifier: context.read<RoomsCubit>().userRoomNotifier,
                        showRooms: showRooms,
                        onToggleRooms: () {
                          setState(() {
                            showRooms = !showRooms;
                          });
                          if (showRooms) {
                            context.read<RoomsCubit>().loadRooms();
                          }
                        },
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                // if _isLoadingForLong is true, show refresh button
                if (_isLoadingForLong)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                        child: ElevatedButton(
                          onPressed: _refreshPage,
                          child: const Text('Refresh'),
                        )),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
