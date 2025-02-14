import 'dart:async';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:islandmfb_flutter_version/components/shared/app_button.dart';
import 'package:islandmfb_flutter_version/components/shared/app_customer_accounts_button.dart';
import 'package:islandmfb_flutter_version/components/shared/app_textfield.dart';
import 'package:islandmfb_flutter_version/models/transfer.dart';
import 'package:islandmfb_flutter_version/pages/home_page.dart';
import 'package:islandmfb_flutter_version/state/account_state_controller.dart';
import 'package:islandmfb_flutter_version/state/transfer_state_controller.dart';
import 'package:islandmfb_flutter_version/utilities/colors.dart';

class OwnAccountTransferPage extends StatefulWidget {
  OwnAccountTransferPage({Key? key}) : super(key: key);

  @override
  State<OwnAccountTransferPage> createState() => _OwnAccountTransferPageState();
}

class _OwnAccountTransferPageState extends State<OwnAccountTransferPage> {
  // Text Controllers
  TextEditingController amountTextController = TextEditingController();
  TextEditingController narrationTextController = TextEditingController();
  TextEditingController pinTextController = TextEditingController();

  // State
  final transferState = Get.put(TransferStateController());

  // Verify Button State
  final _isButtonDisabled = true.obs;
  final _buttonText = "Verify".obs;
  final _isloading = false.obs;

  bool get isButtonDisabled {
    if (transferState.transferToOwnAccountState.value.toAccountNo == null ||
        transferState.transferToOwnAccountState.value.fromAccountNo == null ||
        transferState.transferToOwnAccountState.value.toAccountNo ==
            transferState.transferToOwnAccountState.value.fromAccountNo ||
        amountTextController.text.isEmpty ||
        narrationTextController.text.isEmpty ||
        double.parse(amountTextController.text.replaceAll(",", "")) <= 0 ||
        pinTextController.text.isEmpty) {
      _isButtonDisabled.value = true;
    } else {
      _isButtonDisabled.value = false;
    }

    _isButtonDisabled.refresh();

    return _isButtonDisabled.value;
  }

  Future onVerifyButtonHandler() async {
    transferState.setAmountNarrationPinField(TransferType.toOwnAccount,
        amount: double.parse(amountTextController.text.replaceAll(",", "")),
        narration: narrationTextController.text,
        pin: pinTextController.text);
    _isloading.value = true;
    _buttonText.value = "Loading...";

    _isButtonDisabled.refresh();
    _buttonText.refresh();
    await transferState.makeTransaction(TransferType.toOwnAccount);

    _isloading.value = false;
    _buttonText.value = "Verify";

    _isButtonDisabled.refresh();
    _buttonText.refresh();
    await Get.put(AccountStateController()).refreshAccountsState();
  }

  @override
  Widget build(BuildContext context) {
    print(DateTime.now().millisecondsSinceEpoch);
    return Scaffold(
      // APPBAR
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            onPressed: () {
              Get.back();
              transferState.clearTransferState(TransferType.toOwnAccount);
            },
            icon: SvgPicture.asset(
              "assets/images/back.svg",
              height: 20,
            ),
          ),
        ),
        backgroundColor: whiteColor,
        title: const Text(
          "Transfer",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: blackColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
      ),

      // BODY BACKGROUND COLOR
      backgroundColor: whiteColor,

      // BOTTOM BUTTON
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 20,
        ),
        child: Obx(() => AppButton(
              text: _buttonText.value,
              isDisabled: _isloading.value || isButtonDisabled,
              onPress: () async {
                await onVerifyButtonHandler();
              },
            )),
      ),

      // APP BODY
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "From",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      context: context,
                      builder: (BuildContext context) {
                        return OwnAccountPageBottomSheet(
                          selectionType: TansferSelectionType.from,
                        );
                      });
                },
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            return Text(
                                transferState.transferToOwnAccountState.value
                                        .fromAccountNo ??
                                    "Select Account",
                                style: const TextStyle(
                                    color: lightextColor, fontSize: 16));
                          }),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: greyColor,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "To",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: blackColor,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      context: context,
                      builder: (BuildContext context) {
                        return OwnAccountPageBottomSheet(
                          selectionType: TansferSelectionType.to,
                        );
                      });
                },
                child: Container(
                  height: 70,
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Obx(() {
                            return Text(
                                transferState.transferToOwnAccountState.value
                                        .toAccountNo ??
                                    "Select Account",
                                style: const TextStyle(
                                    color: lightextColor, fontSize: 16));
                          }),
                          const Icon(
                            Icons.arrow_drop_down,
                            color: greyColor,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                textController: amountTextController,
                prefixIcon: Container(
                  margin: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  width: 60,
                  child: const Center(
                    child: Text("N",
                        style: TextStyle(
                            color: whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w900)),
                  ),
                ),
                label: "Amount",
                hint: "Input Amount...",
                textInputType: const TextInputType.numberWithOptions(
                    decimal: true, signed: false),
                inputFormatters: [CurrencyTextInputFormatter(symbol: "")],
                onChanged: (value) {
                  isButtonDisabled;
                  String convertedMoneyText = NumberFormat.decimalPattern("en")
                      .format(int.parse(value));
                  amountTextController.value = TextEditingValue(
                      text: convertedMoneyText,
                      selection: TextSelection.collapsed(
                          offset: convertedMoneyText.length));
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                textController: narrationTextController,
                label: "Narration",
                hint: "Give a narration...",
                onChanged: (value) {
                  isButtonDisabled;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              AppTextField(
                textController: pinTextController,
                label: "Pin",
                hint: "****",
                hideText: true,
                textInputType: const TextInputType.numberWithOptions(
                    decimal: false, signed: false),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                onChanged: (value) {
                  isButtonDisabled;
                },
              ),
              const SizedBox(
                height: 40,
              )
            ],
          ),
        ),
      ),
    );
  }
}

enum TansferSelectionType { to, from }

class OwnAccountPageBottomSheet extends StatelessWidget {
  OwnAccountPageBottomSheet({Key? key, required this.selectionType})
      : super(key: key);

  final nairaFormat = NumberFormat.currency(name: "N  ");
  TansferSelectionType selectionType;
  final accountState = Get.put(AccountStateController());
  final transferState = Get.put(TransferStateController());

  @override
  Widget build(BuildContext context) {
    final customerAccounts = accountState.customerAccounts;
    return Container(
      height: 600,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: whiteColor,
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 40,
                    height: 3,
                    decoration: BoxDecoration(
                        color: blackColor,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (BuildContext context, int index) {
                      return AppCustomerAccountButtons(
                        nairaFormat: nairaFormat,
                        accountNo:
                            customerAccounts[index].primaryAccountNo["_number"],
                        accountBalance:
                            customerAccounts[index].availableBalance,
                        onClick: () {
                          Navigator.pop(context);
                          if (selectionType == TansferSelectionType.to) {
                            transferState.setTransfertoField(
                                TransferType.toOwnAccount,
                                accountNumber: customerAccounts[index]
                                    .primaryAccountNo["_number"]);
                          } else {
                            transferState.setTransferFromField(
                                TransferType.toOwnAccount,
                                accountNumber: customerAccounts[index]
                                    .primaryAccountNo["_number"]);
                          }
                        },
                      );
                    },
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemCount: customerAccounts.length)
              ]),
        ),
      ),
    );
  }
}
