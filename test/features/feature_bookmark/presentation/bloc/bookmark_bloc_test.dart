
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:weatherBs/core/resources/data_state.dart';
import 'package:weatherBs/features/feature_bookmark/domain/entities/city_model.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/delete_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/get_all_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/get_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/domain/use_cases/save_city_usecase.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/bookmark_bloc.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/delete_city_status.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/get_all_city_status.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/get_city_status.dart';
import 'package:weatherBs/features/feature_bookmark/presentation/bloc/save_city_status.dart';

import 'bookmark_bloc_test.mocks.dart';

@GenerateMocks([GetAllCityUseCase,GetCityUseCase,SaveCityUseCase,DeleteCityUseCase])
void main(){
  late BookmarkBloc bookmarkBloc;
  MockGetAllCityUseCase mockGetAllCityUseCase = MockGetAllCityUseCase();
  MockGetCityUseCase mockGetCityUseCase = MockGetCityUseCase();
  MockSaveCityUseCase mockSaveCityUseCase = MockSaveCityUseCase();
  MockDeleteCityUseCase mockDeleteCityUseCase = MockDeleteCityUseCase();

  setUp((){
    bookmarkBloc = BookmarkBloc(mockGetCityUseCase, mockGetAllCityUseCase, mockSaveCityUseCase, mockDeleteCityUseCase);
  });

  tearDown(() {
    bookmarkBloc.close();
  });

  String error = 'error';


  group('GetAllCityEvent test', () {
    List<City> cities = [];

    test('emit Loading and Completed state', () {
      when(mockGetAllCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataSuccess(cities)));

      bookmarkBloc.add(GetAllCityEvent());

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityCompleted(cities),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        )
      ]));
    });

    test('emit Loading and Error state', () {
      when(mockGetAllCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      bookmarkBloc.add(GetAllCityEvent());

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityError(error),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        )
      ]));
    });
  });

  group('GetCityByNameEvent test', () {
    City city = City(name: 'tehran');

    test('emit Loading and Completed state', () {
      when(mockGetCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataSuccess(city)));

      bookmarkBloc.add(GetCityByNameEvent('tehran'));

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityCompleted(city),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        )
      ]));
    });

    test('emit Loading and Error state', () {
      when(mockGetCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      bookmarkBloc.add(GetCityByNameEvent('tehran'));

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityError(error),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityInitial()
        )
      ]));
    });
  });

  group('SaveCwEvent test', () {
    City city = City(name: 'tehran');

    test('emit Loading and Completed state', () {
      when(mockSaveCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataSuccess(city)));

      bookmarkBloc.add(SaveCwEvent('tehran'));

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityLoading(),
            deleteCityStatus: DeleteCityInitial()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityCompleted(city),
            deleteCityStatus: DeleteCityInitial()
        )
      ]));
    });

    test('emit Loading and Error state', () {
      when(mockSaveCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      bookmarkBloc.add(SaveCwEvent('tehran'));

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityLoading(),
            deleteCityStatus: DeleteCityInitial()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityError(error),
            deleteCityStatus: DeleteCityInitial()
        )
      ]));
    });
  });

  group('DeleteCityEvent test', () {
    City city = City(name: 'tehran');

    test('emit Loading and Completed state', () {
      when(mockDeleteCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataSuccess('tehran')));

      bookmarkBloc.add(DeleteCityEvent('tehran'));

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityLoading()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityCompleted('tehran')
        )
      ]));
    });

    test('emit Loading and Error state', () {
      when(mockDeleteCityUseCase.call(any)).thenAnswer((_) async => Future.value(DataFailed(error)));

      bookmarkBloc.add(DeleteCityEvent('tehran'));

      expectLater(bookmarkBloc.stream,emitsInOrder([
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityLoading()
        ),
        BookmarkState(
            getAllCityStatus: GetAllCityLoading(),
            getCityStatus: GetCityLoading(),
            saveCityStatus: SaveCityInitial(),
            deleteCityStatus: DeleteCityError(error)
        )
      ]));
    });
  });

}