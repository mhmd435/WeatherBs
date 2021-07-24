
class ForecastDaysModel{

  var _datetime;
  var _temp;
  String _main;
  String _description;

  ForecastDaysModel(this._datetime, this._temp, this._main, this._description);

  String get description => _description;

  String get main => _main;

  get temp => _temp;

  get datetime => _datetime;

}