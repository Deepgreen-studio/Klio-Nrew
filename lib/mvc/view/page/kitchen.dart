import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:klio_staff/constant/color.dart';
import 'package:klio_staff/constant/value.dart';
import 'package:klio_staff/utils/utils.dart';
import '../../../service/local/shared_pref.dart';
import '../../controller/kitchen_controller.dart';
import '../../model/kitchen_order.dart';
import '../dialog/custom_dialog.dart';
import '../widget/custom_widget.dart';
import 'login.dart';

class Kitchen extends StatefulWidget {
  const Kitchen({Key? key}) : super(key: key);

  @override
  State<Kitchen> createState() => _KitchenState();
}

KitchenController kitchenController = Get.put(KitchenController());

class _KitchenState extends State<Kitchen> {
  ScrollController _scrollController = ScrollController();
  Timer? timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    applyThem(darkMode);

    kitchenController.getKitchenOrder(false).then((value) {
      if (Navigator.of(context).canPop()) {
        print(" popppppppppppppppppppppppppppppppppppppppppppppp");
        Navigator.pop(context);
      }
      setState(() {});
    });
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
      //kitchenController.getKitchenOrder(true);
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: TextStyle(
                              fontSize: fontMediumExtra,
                              fontWeight: FontWeight.bold,
                              color: primaryText),
                        ),
                        Text(
                            DateFormat('kk:mm:a | dd MMM')
                                .format(DateTime.now()),
                            style: TextStyle(
                                fontSize: fontVerySmall, color: primaryText)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                            width: 280,
                            height: 40,
                            child: TextField(
                                onChanged: (text) async {},
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.search,
                                style: const TextStyle(fontSize: fontSmall),
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: secondaryBackground,
                                    prefixIcon: Image.asset("assets/search.png",
                                        color: primaryText),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        Icons.close,
                                        color: textSecondary,
                                      ),
                                      onPressed: () {},
                                    ),
                                    hintText: 'Search item',
                                    hintStyle: TextStyle(
                                        fontSize: fontMedium,
                                        color: primaryText),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                        borderSide: BorderSide.none),
                                    contentPadding: EdgeInsets.zero))),
                        const SizedBox(width: 12),
                        topBarIconBtn(
                            Image.asset('assets/reload.png',
                                color: primaryColor),
                            secondaryBackground,
                            8,
                            15,
                            40, onPressed: () {
                          kitchenController.getKitchenOrder(false);
                        }),
                        const SizedBox(width: 12),
                        topBarIconBtn(
                            Image.asset('assets/moon.png', color: primaryColor),
                            secondaryBackground,
                            8,
                            15,
                            40, onPressed: () {
                          darkMode ? darkMode = false : darkMode = true;
                          applyThem(darkMode);
                          setState(() {});
                        }),
                        const SizedBox(width: 12),
                        topBarIconBtn(
                            Image.asset('assets/logout.png', color: white),
                            primaryColor,
                            8,
                            15,
                            40, onPressed: () {
                          showWarningDialog("Do you want to Logout from app",
                              onAccept: () async {
                            await SharedPref().saveValue('token', '');
                            await SharedPref().saveValue('loginType', '');
                            Get.offAll(const Login());
                          });
                        }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RawScrollbar(
                thumbVisibility: true,
                trackVisibility: true,
                thickness: 12,
                thumbColor: primaryColor,
                radius: const Radius.circular(20),
                controller: _scrollController,
                child:  GetBuilder<KitchenController>(
                  id: 'changeKitchenUi',
                  builder: (Ccontext) {
                   return GridView.count(
                      crossAxisCount: 3,
                      padding: const EdgeInsets.all(15),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      controller: _scrollController,
                      childAspectRatio: (1.1 / 1.2),
                      children: List.generate(
                          kitchenController.kitchenOrder.value.data?.length ?? 0,
                          (index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          elevation: 5,
                          color: secondaryBackground,
                          child: Column(
                            children: [
                              Expanded(
                                  flex: 2, child: topContainer(context, index)),
                              const SizedBox(height: 5),
                              Expanded(
                                flex: 12,
                                child: Obx(() {
                                  return ListView.builder(
                                      itemCount: kitchenController
                                          .kitchenOrder
                                          .value
                                          .data![index]
                                          .orderDetails!
                                          .data!
                                          .length,
                                      itemBuilder:
                                          (BuildContext context, int index2) {
                                        return GestureDetector(
                                            onTap: () {
                                              if (kitchenController
                                                      .kitchenOrder
                                                      .value
                                                      .data![index]
                                                      .orderDetails!
                                                      .data![index2]
                                                      .selected ==
                                                  true) {
                                                kitchenController
                                                    .kitchenOrder
                                                    .value
                                                    .data![index]
                                                    .orderDetails!
                                                    .data![index2]
                                                    .selected = false;
                                              } else {
                                                kitchenController
                                                    .kitchenOrder
                                                    .value
                                                    .data![index]
                                                    .orderDetails!
                                                    .data![index2]
                                                    .selected = true;
                                              }
                                              kitchenController.kitchenOrder
                                                  .refresh();
                                            },
                                            child: innerItemCard(
                                                context, index, index2));
                                      });
                                }),
                              ),
                              Expanded(
                                flex: 2,
                                child: footerCard(index),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topContainer(BuildContext context, int index) {
    String time =
        kitchenController.kitchenOrder.value.data![index].availableTime ??
            "00:00:00";
    int hour = int.parse(time[0] + time[1]);
    int minute = int.parse(time[3] + time[4]);
    int second = int.parse(time[6] + time[7]);
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10.0),
          topLeft: Radius.circular(10.0),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.1,
      width: double.infinity,
      child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      "Invoice: ${kitchenController.kitchenOrder.value.data![index].invoice}",
                      style:
                          const TextStyle(fontSize: fontSmall, color: white)),
                  TimerCountdown(
                    format: CountDownTimerFormat.hoursMinutesSeconds,
                    enableDescriptions: false,
                    timeTextStyle:
                        const TextStyle(color: white, fontSize: fontSmall),
                    colonsTextStyle:
                        const TextStyle(color: white, fontSize: fontSmall),
                    endTime: DateTime.now().add(
                      Duration(
                        hours: hour,
                        minutes: minute,
                        seconds: second,
                      ),
                    ),
                    onEnd: () {},
                  ),
                  /*   Text(
                      kitchenController
                          .kitchenOrder.value.data![index].availableTime
                          .toString(),
                      style: TextStyle(fontSize: fontSmall, color: white)),*/
                ],
              ),
              Text(
                  "Table No: ${kitchenController.kitchenOrder.value.data![index].tables!.toString()}",
                  style: const TextStyle(fontSize: fontSmall, color: white)),
            ],
          )),
    );
  }

  Widget innerItemCard(BuildContext context, int index1, int index2) {
/*    log(
        "---------------------------------------- building ");*/
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: kitchenController.kitchenOrder.value.data![index1].orderDetails!
                    .data![index2].selected ==
                true
            ? greenLight
            : secondaryBackground,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              kitchenController.kitchenOrder.value.data![index1].orderDetails!
                  .data![index2].foodName
                  .toString(),
              style: TextStyle(
                  fontSize: fontSmall,
                  color: primaryText,
                  fontWeight: FontWeight.bold)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                      "Quantity: ${kitchenController.kitchenOrder.value.data![index1].orderDetails!.data![index2].quantity.toString()}",
                      style: TextStyle(
                          fontSize: fontVerySmall,
                          color: textSecondary,
                          fontWeight: FontWeight.w100)),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                      "Size: ${kitchenController.kitchenOrder.value.data![index1].orderDetails?.data![index2].variantName.toString() ?? "null"}",
                      style: TextStyle(
                          fontSize: fontVerySmall,
                          color: textSecondary,
                          fontWeight: FontWeight.w100)),
                ],
              ),
              Obx(() {
                return SizedBox(
                    width: 110,
                    height: 40,
                    child: normalButton(
                        kitchenController.kitchenOrder.value.data![index1]
                            .orderDetails!.data![index2].status
                            .toString(),
                        kitchenController.kitchenOrder.value.data![index1]
                                    .orderDetails!.data![index2].status ==
                                'pending'
                            ? red
                            : kitchenController.kitchenOrder.value.data![index1]
                                        .orderDetails!.data![index2].status ==
                                    'ready'
                                ? green
                                : blue,
                        white,
                        onPressed: () {}));
              }),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: kitchenController.kitchenOrder.value
                .data![index1].orderDetails!.data![index2].addons!.data!.isEmpty? 0 : 35,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (AddonsDatum addons in kitchenController.kitchenOrder.value
                    .data![index1].orderDetails!.data![index2].addons!.data!
                    .toList())
                  Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                          color: alternate,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text('${addons.name} - ${addons.quantity}',
                          style: TextStyle(
                              fontSize: fontVerySmall, color: primaryText)))
              ],
            ),
          ),
          Divider(color: textSecondary, thickness: 1),
        ],
      ),
    );
  }

  Widget footerCard(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: 110,
          height: 40,
          child: normalButton('Select All', primaryBackground, primaryText,
              onPressed: () {
            for (int i = 0;
                i <
                    kitchenController.kitchenOrder.value.data![index]
                        .orderDetails!.data!.length;
                i++) {
              kitchenController.kitchenOrder.value.data![index].orderDetails!
                  .data![i].selected = true;
            }
            kitchenController.kitchenOrder.refresh();
          }),
        ),
        SizedBox(
          width: 110,
          height: 40,
          child: normalButton('Unselect All', primaryBackground, primaryText,
              onPressed: () {
            for (int i = 0;
                i <
                    kitchenController.kitchenOrder.value.data![index]
                        .orderDetails!.data!.length;
                i++) {
              kitchenController.kitchenOrder.value.data![index].orderDetails!
                  .data![i].selected = false;
            }
            kitchenController.kitchenOrder.refresh();
          }),
        ),
        SizedBox(
            width: 70,
            height: 40,
            child:
                normalButton('Cook', primaryColor, white, onPressed: () async {
              changeStatus('cooking', index);
            })),
        SizedBox(
            width: 70,
            height: 40,
            child:
                normalButton('Ready', primaryColor, white, onPressed: () async {
              changeStatus('ready', index);
            })),
      ],
    );
  }

  Future<void> changeStatus(String status, int index) async {

    Utils.showLoading();
    List<int> itemList = [];
    for (var element in kitchenController
        .kitchenOrder.value.data![index].orderDetails!.data!) {
      if (element.selected == true) {
        itemList.add(element.id!.toInt());
      }
    }
    if (itemList.isNotEmpty) {
      bool done = await kitchenController.acceptOrder(
          kitchenController.kitchenOrder.value.data![index].id!.toInt(),
          itemList,
          status);
      if (done) {
        // Utils.showSnackBar('Order updated successfully');
        await kitchenController.getKitchenOrder(false);
        kitchenController.kitchenOrder.refresh();
        Utils.hidePopup();
      }
      Utils.hidePopup();
    }
  }
}
