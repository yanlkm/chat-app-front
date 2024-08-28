import '../../models/users/user_model.dart';

//  Users Data Source
abstract class UsersDataSource {

  // Get user
  Future<UserModel> getUser();

  // Get all users
  Future<List<UserModel>> getUsers();

  // Update Username
  Future<String> updateUsername(String username);

  // Update Password
  Future<String> updatePassword(String oldPassword, String newPassword);

  // Ban User
  Future<String> banUser(String userToBanId);

  // Unban User
  Future<String> unbanUser(String userToUnbanId);

  Future<String> createRegistrationCode(String code);
}