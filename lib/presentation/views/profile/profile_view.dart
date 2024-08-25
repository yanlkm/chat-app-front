import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_app/domain/entities/users/user_entity.dart';
import 'package:my_app/domain/use_cases/authentication/auth_usecases.dart';
import 'package:my_app/presentation/pages/home/base/base_page.dart';
import '../../_widgets/profile/update_password_widget.dart';
import '../../_widgets/profile/user_profile_widget.dart';
import '../../_widgets/profile/user_rooms_widget.dart';
import '../../cubits/profile/password_cubit.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/profile/rooms_cubit.dart';


class ProfileView extends StatefulWidget {
  final AuthUseCases authUseCases;

  const ProfileView({
    super.key,
    required this.authUseCases,
  });

  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> {
  bool showRooms = false;
  bool showPasswords = false;
  bool isEditingUsername = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  void togglePasswords() {
    setState(() {
      showPasswords = !showPasswords;
    });
  }

  void saveUsername() {
    context.read<ProfileCubit>().updateUsername(usernameController.text);
    setState(() {
      isEditingUsername = false;
    });
  }

  void updatePassword(String oldPassword, String newPassword) {
    context.read<PasswordCubit>().updatePassword(oldPassword, newPassword);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      showFooter: false,
      authUseCases: widget.authUseCases,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileCubit>().loadProfile();
            context.read<RoomsCubit>().loadRooms();
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                BlocListener<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileLoaded) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                      usernameController.clear();
                    }
                    if (state is ProfileError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
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

                                if (showPasswords)
                                  BlocListener<PasswordCubit, PasswordState>(
                                    listener: (context, state) {
                                      if (state is PasswordUpdated) {
                                        setState(() {
                                          user = user.setUpdatedAt(DateTime.now());
                                          // TODO: Update user
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
