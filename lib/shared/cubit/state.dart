part of 'cubit.dart';

@immutable
abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppChangeBottomNavBarState extends AppStates {}

class AppCreateDataBaseState extends AppStates {}

class AppGetDataBaseState extends AppStates {}

class AppGetDataBaseLoadingState extends AppStates {}

class AppInsertDataBaseState extends AppStates {}

class AppChangeBottomSheetState extends AppStates {}
