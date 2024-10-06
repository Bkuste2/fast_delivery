import '../model/address_model.dart';
import '../repositories/local_storage_repository.dart';

class HomeController {
  final LocalStorageRepository _localStorageRepository;

  HomeController(this._localStorageRepository);

  Future<void> addAddress(String street, String city) async {
    final address = Address(street: street, city: city);
    await _localStorageRepository.addAddress(address);
  }

  List<Address> getAddresses() {
    return _localStorageRepository.getAddresses();
  }
}
