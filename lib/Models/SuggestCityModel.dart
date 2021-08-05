class SuggestCityModel{
  String _Name;
  String _region;
  String _country;
  String _countryCode;

  SuggestCityModel(this._Name, this._region, this._country, this._countryCode);

  String get countryCode => _countryCode;

  String get country => _country;

  String get region => _region;

  String get Name => _Name;
}