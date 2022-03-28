abstract class TodoStates {}

class TodoInitState extends TodoStates{}
class TodoChangeBottomNavBarState extends TodoStates{}



class TodoCreateDatabaseSuccessState extends TodoStates{}
class TodoGetDatabaseLoadingState extends TodoStates{}
class TodoGetDatabaseSuccessState extends TodoStates{}
class TodoInsertDatabaseSuccessState extends TodoStates{}
class TodoUpdateDatabaseSuccessState extends TodoStates{}
class TodoDeleteDatabaseSuccessState extends TodoStates{}

class TodoChangeBottomSheetState extends TodoStates{}