import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controllers/authentification/logout_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../controllers/user/user_rooms_controller.dart';
import '../../../models/room.dart';
import '../../../models/user.dart';
import '../../../views/home/base_page.dart';
import '../../../views/utils/error_popup.dart';
import '../../_widgets/profile/update_password_widget.dart';
import '../../_widgets/profile/user_profile_widget.dart';
import '../../_widgets/profile/user_rooms_widget.dart';
import '../../cubits/profile/password_cubit.dart';
import '../../cubits/profile/profile_cubit.dart';
import '../../cubits/profile/rooms_cubit.dart';

class ProfilePage extends StatelessWidget {
  final UserController userController;
  final UserRoomsController userRoomsController;
  final LogoutController logoutController;
  final ValueNotifier<List<Room>> roomsNotifier;

  const ProfilePage({
    super.key,
    required this.userController,
    required this.userRoomsController,
    required this.logoutController,
    required this.roomsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(userController)..loadProfile(),
        ),
        BlocProvider(
          create: (context) => RoomsCubit(userRoomsController, roomsNotifier)..loadRooms(),
        ),
        BlocProvider(
          create: (context) => PasswordCubit(userController),
        ),
      ],
      child: ProfileView(
        logoutController: logoutController,
      ),
    );
  }
}

class ProfileView extends StatefulWidget {
  final LogoutController logoutController;

  const ProfileView({
    Key? key,
    required this.logoutController,
  }) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  bool showRooms = false;
  bool showPasswords = false;
  bool isEditingUsername = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BasePage(
      showFooter: true,
      logoutController: widget.logoutController,
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileCubit>().loadProfile();
            context.read<RoomsCubit>().loadRooms();
          },
          child: SingleChildScrollView(
            child:
          Column(
            children: [
              BlocListener<ProfileCubit, ProfileState>(
                listener: (context, state) {
                  if (state is ProfileLoaded) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),

                    );
                    usernameController.clear();
                  } else if (state is ProfileError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  }
                },
                child: BlocBuilder<ProfileCubit, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProfileError) {
                      return const Center(child: Text('An error occurred'));
                    } else if (state is ProfileLoaded) {
                      User user = state.user;
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
                                onSavePressed: () {
                                  context.read<ProfileCubit>().updateUsername(usernameController.text);
                                  setState(() {
                                    isEditingUsername = false;
                                  });
                                }, updatePassword: (oldPassword, newPassword) {
                                  context.read<PasswordCubit>().updatePassword(oldPassword, newPassword);
                                },
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
                      roomsNotifier: context.read<RoomsCubit>().roomsNotifier,
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
