import 'package:get/get.dart';
import 'package:islandmfb_flutter_version/models/account.dart';
import 'package:islandmfb_flutter_version/requests/account_request.dart';
import 'package:islandmfb_flutter_version/state/transactions_state_controller.dart';
import 'package:islandmfb_flutter_version/state/user_state_controller.dart';

class AccountStateController extends GetxController {
  final customerAccounts = <Account>[].obs;
  final selectedAccount = const Account().obs;
  final customerDetails = {}.obs;

  Future setAccountStateFromLogin(String customerNo) async {
    var customerAccountsResponse = await getCustomerAccounts(customerNo);
    print(customerAccountsResponse);
    var customerDetailsResponse = await getCustomerDetails(customerNo);
    if (customerAccountsResponse["success"] == true &&
        customerDetailsResponse["success"] == true) {
      customerAccounts.value = (customerAccountsResponse["data"])
          .map<Account>((account) => Account.fromJson(account))
          .toList();
      selectedAccount.value = customerAccounts[0];
      customerDetails.value = customerDetailsResponse["data"];
    }
  }

  Future refreshAccountsState() async {
    final userState = Get.put(UserStateController());
    var customerAccountsResponse =
        await getCustomerAccounts(userState.user["customer_no"].toString());
    if (customerAccountsResponse["success"] == true) {
      customerAccounts.value = (customerAccountsResponse["data"])
          .map<Account>((account) => Account.fromJson(account))
          .toList();

      selectedAccount.value = customerAccounts.firstWhere((account) =>
          account.primaryAccountNo["_number"] ==
          selectedAccount.value.primaryAccountNo["_number"]);
    }
  }

  void changeSelectedAccount(Account otherAccount) {
    selectedAccount.value =
        customerAccounts.firstWhere((account) => account == otherAccount);
    Get.put(TransactionStateController()).setRecentTransactionHistory();
  }

  void clearAccoutState() {
    customerAccounts.value = [];
    selectedAccount.value = const Account();
    customerDetails.value = {};
  }
}
