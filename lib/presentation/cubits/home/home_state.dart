part of 'home_cubit.dart';

// HomeState
class HomeState extends Equatable {
  // selectedIndex, isAdmin as attributes
  final int selectedIndex;
  final bool isAdmin;

  // Constructor
  const HomeState({required this.selectedIndex, required this.isAdmin});

  // copyWith method
  HomeState copyWith({int? selectedIndex, bool? isAdmin}) {
    return HomeState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isAdmin: isAdmin ?? this.isAdmin,
    );
  }

  // props
  @override
  List<Object> get props => [selectedIndex, isAdmin];
}
