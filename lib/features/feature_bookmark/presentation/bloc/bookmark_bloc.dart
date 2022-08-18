import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/get_all_city_status.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/get_city_status.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/save_city_status.dart';
import '../../../../core/resources/data_state.dart';
import '../../../../core/usecases/UseCase.dart';
import '../../domain/use_cases/get_all_city_usecase.dart';
import '../../domain/use_cases/get_city_usecase.dart';
import '../../domain/use_cases/save_city_usecase.dart';
import 'delete_city_status.dart';
part 'bookmark_state.dart';
part 'bookmark_event.dart';

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
      emit(state.copyWith(newAllCityStatus: GetAllCityLoading()));

      DataState dataState = await getAllCityUseCase(NoParams());

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newAllCityStatus: GetAllCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newAllCityStatus: GetAllCityError(dataState.error)));
      }
    });

    /// get city By name event
    on<GetCityByNameEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(newCityStatus: GetCityLoading()));

      DataState dataState = await getCityUseCase(event.cityName);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newCityStatus: GetCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newCityStatus: GetCityError(dataState.error)));
      }
    });


    /// Save City Event
    on<SaveCwEvent>((event, emit) async {

      /// emit Loading state
      emit(state.copyWith(newSaveStatus: SaveCityLoading()));

      DataState dataState = await saveCityUseCase(event.name);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newSaveStatus: SaveCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newSaveStatus: SaveCityError(dataState.error)));
      }
    });

    /// set to init again SaveCity (برای بار دوم و سوم و غیره باید وضعیت دوباره به حالت اول برگرده وگرنه بوکمارک پر خواهد ماند)
    on<SaveCityInitialEvent>((event, emit) async {
      emit(state.copyWith(newSaveStatus: SaveCityInitial()));
    });


    /// City Delete Event
    on<DeleteCityEvent>((event, emit) async {
      /// emit Loading state
      emit(state.copyWith(newDeleteStatus: DeleteCityLoading()));

      DataState dataState = await deleteCityUseCase(event.name);

      /// emit Complete state
      if(dataState is DataSuccess){
        emit(state.copyWith(newDeleteStatus: DeleteCityCompleted(dataState.data)));
      }

      /// emit Error state
      if(dataState is DataFailed){
        emit(state.copyWith(newDeleteStatus: DeleteCityError(dataState.error)));
      }
    });
  }
}
