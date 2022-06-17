import 'package:demo_application/module/home/model/user_model.dart';
import 'package:get/state_manager.dart';
import '../../../core/db_helper.dart';

class UserProfileScreenController extends GetxController {
  final Databasehelper _databasehelper = Databasehelper();
  Future<void> insertdata(
      {required String id, required String bio, required int favourite}) async {
    await _databasehelper.update(User(id: id, favourite: favourite, bio: bio));

    // Map<String, dynamic> userData = {
    //   Databasehelper.columnBio: bio,
    //   Databasehelper.columnFavourite: favourite
    // };
  }
}
