import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../Models/ProviderModel.dart';
import '../Services/provider_service.dart';

class ProviderController extends GetxController {
  var providers = <ProviderModel>[].obs;
  var isLoading = true.obs;

  final ProviderService _service = ProviderService();

  @override
  void onInit() {
    super.onInit();
    fetchProviders();
  }

  void fetchProviders() async {
    try {
      isLoading.value = true;
      final result = await _service.fetchProviders();
      providers.assignAll(result);
    } catch (e) {
      print("Controller Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> fetchProvidersByCategory(String categoryName) async {
    try {
      isLoading.value = true;
      providers.clear();

      final snapshot = await FirebaseFirestore.instance
          .collection('Provider')
          .where('service', isEqualTo: categoryName)
          .get();

      final List<ProviderModel> fetched = snapshot.docs
          .map((doc) => ProviderModel.fromMap(doc.data(), doc.id))
          .toList();

      providers.assignAll(fetched);
    } catch (e) {
      print("Error fetching providers for $categoryName: $e");
    } finally {
      isLoading.value = false;
    }
  }

}
