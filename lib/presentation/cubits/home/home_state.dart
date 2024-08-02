part of 'home_cubit.dart';

class HomeState extends Equatable {
  final int selectedIndex;
  final bool isAdmin;

  const HomeState({required this.selectedIndex, required this.isAdmin});

  HomeState copyWith({int? selectedIndex, bool? isAdmin}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  @override
  List<Object> get props => [selectedIndex, isAdmin];
}
