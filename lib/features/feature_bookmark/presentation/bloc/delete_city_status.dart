

abstract class DeleteCityStatus {}

class DeleteCityInitial extends DeleteCityStatus {}

// loading state
class DeleteCityLoading extends DeleteCityStatus{}

// loaded state
class DeleteCityCompleted extends DeleteCityStatus{
  final String name;
  DeleteCityCompleted(this.name);
}

// error state
class DeleteCityError extends DeleteCityStatus{
  final String? message;
  DeleteCityError(this.message);
}
