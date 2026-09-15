import 'package:core/log/log.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:station/model/station_model.dart';
import 'package:station/repository/station_repository.dart';

abstract class FavoriteStationRepository {
  Stream<Result<List<StationModel>, Exception>> list();

  Stream<Result<bool, Exception>> exists(int stationId);

  Future<Result<void, Exception>> add(int stationId);

  Future<Result<void, Exception>> delete(int stationId);
}

class PreferencesFavoriteStationRepository extends FavoriteStationRepository {
  static final PreferencesFavoriteStationRepository _instance =
      PreferencesFavoriteStationRepository._internal();

  final String preferencesKey = "favorite_stations";

  late StationRepository _stationRepository;
  late SharedPreferencesAsync _sharedPreferences;

  factory PreferencesFavoriteStationRepository(
    StationRepository stationRepository,
    SharedPreferencesAsync sharedPreferences,
  ) {
    _instance._stationRepository = stationRepository;
    _instance._sharedPreferences = sharedPreferences;
    return _instance;
  }

  PreferencesFavoriteStationRepository._internal();

  final BehaviorSubject<Result<List<StationModel>, Exception>> _listSubject =
      BehaviorSubject();
  final Map<int, BehaviorSubject<Result<bool, Exception>>> _existsSubjects = {};

  @override
  Stream<Result<List<StationModel>, Exception>> list() {
    if (!_listSubject.hasValue) {
      _fetchList();
    }

    return _listSubject.stream;
  }

  void _fetchList() {
    _fetchListAsync().then((result) => _listSubject.add(result));
  }

  Future<Result<List<StationModel>, Exception>> _fetchListAsync() async {
    try {
      List<int> stationIds = await _getFavoriteStationIds().then(
        (stationIds) => stationIds
            .map((stationIdString) => int.parse(stationIdString))
            .toList(growable: false),
      );

      List<StationModel> stations = await Future.wait(
        stationIds.map(
          (stationId) => _stationRepository
              .get(stationId)
              .first
              .then((result) => result.getOrThrow()),
        ),
      );
      return Result.success(stations);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Stream<Result<bool, Exception>> exists(int stationId) {
    BehaviorSubject<Result<bool, Exception>> existsSubject = _existsSubjects
        .putIfAbsent(stationId, () => BehaviorSubject());
    if (!existsSubject.hasValue) {
      _exists(stationId);
    }

    return existsSubject.stream;
  }

  void _exists(int stationId) {
    BehaviorSubject<Result<bool, Exception>> existsSubject = _existsSubjects
        .putIfAbsent(stationId, () => BehaviorSubject());

    _existsAsync(stationId).then((result) {
      existsSubject.add(result);
    });
  }

  Future<Result<bool, Exception>> _existsAsync(int stationId) async {
    try {
      final List<String> stationIds = await _getFavoriteStationIds();
      final bool exists = stationIds.contains(stationId.toString());
      return Result.success(exists);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void, Exception>> add(int stationId) {
    return _addAsync(stationId).then((result) {
      _fetchList();
      _exists(stationId);
      return result;
    });
  }

  Future<Result<void, Exception>> _addAsync(int stationId) async {
    try {
      final List<String> stationIds = await _getFavoriteStationIds();
      await _sharedPreferences.setStringList(
        preferencesKey,
        stationIds + [stationId.toString()],
      );

      return Result.success(null);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  @override
  Future<Result<void, Exception>> delete(int stationId) {
    return _deleteAsync(stationId).then((result) {
      _fetchList();
      _exists(stationId);
      return result;
    });
  }

  Future<Result<void, Exception>> _deleteAsync(int stationId) async {
    try {
      final List<String> stationIds = await _getFavoriteStationIds();
      stationIds.remove(stationId.toString());
      await _sharedPreferences.setStringList(preferencesKey, stationIds);

      return Result.success(null);
    } on Exception catch (e) {
      Log.exception(e);
      return Result.error(e);
    }
  }

  Future<List<String>> _getFavoriteStationIds() async {
    return await _sharedPreferences.getStringList(preferencesKey) ?? [];
  }
}
