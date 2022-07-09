import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weatherBs/domain/use_case/delete_city_usecase.dart';
import 'package:weatherBs/presentation/bloc/bookmark_bloc/get_all_city_status.dart';
import 'package:weatherBs/presentation/bloc/bookmark_bloc/get_city_status.dart';
import 'package:weatherBs/presentation/bloc/bookmark_bloc/save_city_status.dart';
import '../../../core/resources/data_state.dart';
import '../../../domain/use_case/get_all_city_usecase.dart';
import '../../../domain/use_case/get_city_usecase.dart';
import '../../../domain/use_case/save_city_usecase.dart';
import 'delete_city_status.dart';
part 'bookmark_event.dart';
part 'bookmark_state.dart';

class BookmarkBloc extends Bloc<BookmarkEvent, BookmarkState> {
  GetAllCityUseCase getAllCityUseCase;
  GetCityUseCase getCityUseCase;
  SaveCityUseCase saveCityUseCase;
  DeleteCityUseCase deleteCityUseCase;

  BookmarkBloc(this.getCityUseCase, this.getAllCityUseCase, this.saveCityUseCase, this.deleteCityUseCase) : super(
      BookmarkState(
          getAllCityStatus: GetAllCityLoading(),
          getCityStatus: GetCityLoading(),
          saveCityStatus: SaveCityInitial(),
          deleteCityStatus: DeleteCityInitial()
      )) {

    /// get All city
    on<GetAllCityEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(GetAllCityLoading(),null,null,null));

      DataState dataState = await getAllCityUseCase.call();

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(GetAllCityCompleted(dataState.data),null,null,null));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(GetAllCityError(dataState.error),null,null,null));
      }
    });

    /// get city By name event
    on<GetCityByNameEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(null, GetCityLoading(), null,null));

      DataState dataState = await getCityUseCase.call(event.cityName);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(null, GetCityCompleted(dataState.data), null,null));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(null, GetCityError(dataState.error), null,null));
      }
    });


    /// Save City Event
    on<SaveCwEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(null, null, SaveCityLoading(),null));

      DataState dataState = await saveCityUseCase.call(event.name);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(null, null, SaveCityCompleted(dataState.data),null));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(null, null, SaveCityError(dataState.error),null));
      }
    });

    /// set to init again SaveCity (برای بار دوم و سوم و غیره باید وضعیت دوباره به حالت اول برگرده وگرنه بوکمارک پر خواهد ماند)
    on<SaveCityInitialEvent>((event, emit) async {
      emit(state.copyWith(null, null, SaveCityInitial(),null));
    });


    /// City Delete Event
    on<DeleteCityEvent>((event, emit) async {
      /// emit Loading state
      emit(state.copyWith(null,null,null, DeleteCityLoading()));

      DataState dataState = await deleteCityUseCase.call(event.name);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(null,null,null, DeleteCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(null,null,null, DeleteCityError(dataState.error)));
      }
    });
  }
}
