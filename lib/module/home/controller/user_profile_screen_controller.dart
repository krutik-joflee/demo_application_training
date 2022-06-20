import 'package:demo_application/module/home/model/user_model.dart';
import 'package:get/state_manager.dart';
import '../../../core/db_helper.dart';

class UserProfileScreenController extends GetxController {
  final Databasehelper dbhelper = Databasehelper();
  Future<void> insertdata(
      {required String id, required String bio, required int favourite}) async {
    await dbhelper.update(User(id: id, favourite: favourite, bio: bio));
  }
}
