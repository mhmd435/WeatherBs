part of 'bookmark_bloc.dart';

class BookmarkState extends Equatable{
  GetAllCityStatus getAllCityStatus;
  GetCityStatus getCityStatus;
  SaveCityStatus saveCityStatus;
  DeleteCityStatus deleteCityStatus;

  BookmarkState({
    required this.getAllCityStatus,
    required this.getCityStatus,
    required this.saveCityStatus,
    required this.deleteCityStatus
  });

  BookmarkState copyWith({
    GetAllCityStatus? newAllCityStatus,
    GetCityStatus? newCityStatus,
    SaveCityStatus? newSaveStatus,
    DeleteCityStatus? newDeleteStatus
  }){
    return BookmarkState(
        getAllCityStatus: newAllCityStatus ?? this.getAllCityStatus,
        getCityStatus: newCityStatus ?? this.getCityStatus,
        saveCityStatus: newSaveStatus ?? this.saveCityStatus,
        deleteCityStatus: newDeleteStatus ?? this.deleteCityStatus
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    getAllCityStatus,
    getCityStatus,
    saveCityStatus,
    deleteCityStatus
  ];
}
