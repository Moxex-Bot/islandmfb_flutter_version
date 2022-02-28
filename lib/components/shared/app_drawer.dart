import 'package:flutter/material.dart';
import 'package:flutter_initicon/flutter_initicon.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:islandmfb_flutter_version/components/shared/app_alert_dialogue.dart';
import 'package:islandmfb_flutter_version/pages/lets_get_started_page.dart';
import 'package:islandmfb_flutter_version/pages/login_page.dart';
import 'package:islandmfb_flutter_version/utilities/colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    void onLogoutClick() {
      showDialog(
          context: context,
          builder: (BuildContext context) => AppAlertDialogue(
                content: "Are you sure you want to Logout?",
                contentColor: blackColor,
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.to(const LetsGetStartedPage());
                    },
                    child: const Text(
                      "Yes",
                      style: TextStyle(
                        color: blackColor,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "No",
                      style: TextStyle(
                        color: blackColor,
                      ),
                    ),
                  ),
                ],
              ),
          barrierDismissible: true);
    }

    return Drawer(
      backgroundColor: whiteColor,
      child: Flexible(
        flex: 1,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Column(
            children: [
              Flexible(
                flex: 3,
                child: Row(
                  children: [
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Center(
                            child: Initicon(
                              text: "Akinloluwa Adeleye",
                              backgroundColor: primaryColor,
                              size: 50,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            "Akinloluwa Adeleye",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("BVN: " + "222900866343",
                              style: TextStyle(fontSize: 12)),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                  flex: 6,
                  child: Column(
                    children: [
                      DrawerNavButtons(
                        name: "Accounts",
                        svgUrl: "assets/images/drawerAccounts.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Transfer",
                        svgUrl: "assets/images/drawerTransfer.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Loan",
                        svgUrl: "assets/images/drawerLoan.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Airtime",
                        svgUrl: "assets/images/drawerAirtime.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Bill payment",
                        svgUrl: "assets/images/drawerBillPayment.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Self service",
                        svgUrl: "assets/images/drawerSelfService.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Self service",
                        svgUrl: "assets/images/drawerSelfService.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Profile",
                        svgUrl: "assets/images/drawerProfile.svg",
                        onClickHandler: () {},
                      ),
                      DrawerNavButtons(
                        name: "Set PIN",
                        svgUrl: "assets/images/drawerSetPin.svg",
                        onClickHandler: () {},
                      ),
                    ],
                  )),
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        DrawerNavButtons(
                          name: "Logout",
                          svgUrl: "assets/images/drawerLogout.svg",
                          onClickHandler: onLogoutClick,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerNavButtons extends StatelessWidget {
  const DrawerNavButtons(
      {Key? key,
      required this.name,
      required this.svgUrl,
      required this.onClickHandler})
      : super(key: key);

  final String name;
  final String svgUrl;
  final onClickHandler;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onClickHandler();
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Ink(
          child: Row(
            children: [
              name == "Profile"
                  ? const SizedBox(width: 2)
                  : const SizedBox(
                      width: 0,
                    ),
              SvgPicture.asset(
                svgUrl,
              ),
              const SizedBox(
                width: 10,
              ),
              name == "Profile"
                  ? const SizedBox(width: 3)
                  : const SizedBox(
                      width: 0,
                    ),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
