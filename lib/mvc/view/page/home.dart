import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:klio_staff/mvc/view/page/food_management.dart';
import 'package:klio_staff/mvc/view/page/login.dart';
import 'package:klio_staff/mvc/view/page/purchase_management.dart';
import 'package:klio_staff/mvc/view/page/reports.dart';
import 'package:klio_staff/mvc/view/page/settings.dart';
import 'package:klio_staff/mvc/view/page/transection_management.dart';
import 'package:klio_staff/utils/utils.dart';
import '../../../constant/color.dart';
import '../../../constant/value.dart';
import '../../../service/local/shared_pref.dart';
import '../../controller/food_management_controller.dart';
import '../../controller/home_controller.dart';
import '../../model/menu.dart';
import '../../model/order.dart';
import '../dialog/custom_dialog.dart';
import '../widget/custom_widget.dart';
import 'Ingredient_management.dart';
import 'customer_management.dart';
import 'dashboard.dart';
import 'drawer.dart';
import 'home_left_view.dart';
import 'orders_management.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.refresh = true}) : super(key: key);
  final bool refresh;

  @override
  _HomeState createState() => _HomeState();
}

List pageList = [
  0,
  const Dashboard(),
  const FoodManagement(),
  const OrdersManagement(),
  const PurchaseManagement(),
  const IngredientManagement(),
  const TransactionManagement(),
  const CustomerManagement(),
  const Reports(),
  Settings()
];

class _HomeState extends State<Home> {
  HomeController homeController = Get.put(HomeController());
  TextEditingController? textController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  int selectedCategory = -1;
  bool gridImage = true;
  FoodManagementController foodCtlr = Get.put(FoodManagementController());

  @override
  void initState() {
    super.initState();

    applyThem(darkMode);
    if (widget.refresh) {
      homeController.loadHomeData();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: primaryBackground,
      drawer: sideDrawer(),
      endDrawer: leftSideView(context, scaffoldKey.currentState),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              /*mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,*/
              children: [
                Obx(
                  () => SizedBox(
                    width: homeController.currentPage.value == 0
                        ? size.width > 1200
                            ? size.width * 0.7
                            : size.width
                        : size.width,
                    child: SizedBox(
                      height: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          buildHomeTop(context),
                          homeController.currentPage.value == 0
                              ? Expanded(
                                  child: Column(
                                    children: [
                                      buildTabBar(),
                                      buildMenuItems(size),
                                      buildOrdersList(context),
                                    ],
                                  ),
                                )
                              : pageList[homeController.currentPage.value]
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: Obx(() {
                    return homeController.currentPage.value == 0
                        ? size.width > 1200
                            ? SizedBox(
                                width: size.width * 0.3,
                                height: size.height,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: size.height * 0.005,
                                      bottom: size.height * 0.02),
                                  child: leftSideView(
                                      context, scaffoldKey.currentState),
                                ),
                              )
                            : SizedBox(
                                height: size.height,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 30,
                                      padding: EdgeInsets.zero,
                                      margin: EdgeInsets.zero,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(100),
                                            bottomLeft: Radius.circular(100)),
                                        color: primaryColor,
                                      ),
                                      child: MaterialButton(
                                          onPressed: () {
                                            scaffoldKey.currentState!
                                                .openEndDrawer();
                                          },
                                          padding: const EdgeInsets.all(12),
                                          child: const Icon(
                                            Icons.arrow_back_ios,
                                            color: white,
                                          )),
                                    )
                                  ],
                                ),
                              )
                        : const SizedBox();
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildOrdersList(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150,
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      decoration: BoxDecoration(
        color: secondaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Obx(() {
              print("********************************************* 123321");
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: homeController.orders.value.data!.length,
                itemBuilder: (context, index) {
                  String value = homeController
                                  .orders.value.data![index].customerName !=
                              null &&
                          homeController.orders.value.data![index].customerName!
                              .isNotEmpty
                      ? "C Name : ${homeController.orders.value.data![index].customerName}"
                      : "Invoice : ${homeController.orders.value.data![index].invoice.toString()}";
                  return Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    color: alternate,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: homeController.selectedOrder == index
                            ? const BorderSide(width: 2, color: primaryColor)
                            : BorderSide.none),
                    child: Container(
                      width: 250,
                      alignment: Alignment.center,
                      color: alternate,
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            homeController.selectedOrder.value = index;
                          });
                        },
                        leading: Image.asset(
                          orderTypes[homeController
                              .orders.value.data![index].type
                              .toString()],
                          color: primaryColor,
                        ),
                        title: Text(
                            homeController.orders.value.data![index].type
                                    .toString() ??
                                '',
                            style: TextStyle(
                                fontSize: fontMedium,
                                color: primaryText,
                                fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Table : ${Utils.getTables(homeController.orders.value.data![index].tables!.data!)}\n $value',
                            style: TextStyle(
                              fontSize: fontVerySmall,
                              color: primaryText,
                            )),
                        tileColor: secondaryBackground,
                        dense: false,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          Expanded(
            flex: 2,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                bottomIconTextBtn(
                    'assets/delivery.png', 'Order Detail', primaryColor,
                    onPressed: () async {
                  Utils.showLoading();
                  await homeController.getOrder(homeController.orders.value
                      .data![homeController.selectedOrder.value].id!
                      .toInt());
                  Utils.hidePopup();
                  showCustomDialog(
                      context, "Order Details", orderDetail(context), 50, 400);
                }),
                const SizedBox(width: 8),
                bottomIconTextBtn(
                    'assets/circle-error.png', 'Cancel Order', primaryColor,
                    onPressed: () {
                  showWarningDialog('Are you sure to cancel this order?',
                      onAccept: () async {
                    Utils.showLoading();
                    await homeController.cancelOrder(homeController.orders.value
                        .data![homeController.selectedOrder.value].id!
                        .toInt());
                    homeController.getOrders();
                    Utils.hidePopup();
                    Utils.hidePopup();
                    Utils.showSnackBar("Order canceled successfully");
                  });
                }),
                const SizedBox(width: 8),
                bottomIconTextBtn(
                    'assets/edit-alt.png', 'Edit Order', primaryColor,
                    onPressed: () {
                  showWarningDialog('Are you sure to edit this order?',
                      onAccept: () async {
                    Utils.showLoading();
                    homeController.cardList.clear();
                    await homeController.getOrder(homeController.orders.value
                        .data![homeController.selectedOrder.value].id!
                        .toInt());
                    for (OrderDetailsDatum order in homeController
                        .order.value.data!.orderDetails!.data!
                        .toList()) {
                      MenuData menuData = await MenuData(
                          id: order.foodId,
                          name: order.food!.name,
                          taxVat: order.vat,
                          quantity: order.quantity,
                          variant: order.variantId.toString(),
                          addons: order.addons,
                          variants: Variants(data: [
                            VariantsDatum(
                                id: order.variantId,
                                name: order.variant!.name,
                                price: order.price)
                          ]));
                      homeController.cardList.add(menuData);
                      homeController.update(["cardUpdate"]);
                    }
                    homeController.isUpdate.value = true;
                    Utils.hidePopup();
                    Utils.hidePopup();
                  });
                }),
                const SizedBox(width: 8),
                bottomIconTextBtn(
                    'assets/delivery.png', 'Kitchen Status', primaryColor,
                    onPressed: () async {
                  Utils.showLoading();
                  await homeController.getOrder(homeController.orders.value
                      .data![homeController.selectedOrder.value].id!
                      .toInt());
                  Utils.hidePopup();
                  print(homeController.order.value.toJson());
                  showCustomDialog(context, "Order Status",
                      orderDetail(context, true), 100, 400);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildMenuItems(Size size) {
    return Expanded(
      child: Obx(() {
        return GridView.builder(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 10, 15, 10),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: size.width > size.height ? 3 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          scrollDirection: Axis.vertical,
          itemCount: homeController.filteredMenu.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              decoration: BoxDecoration(
                color: secondaryBackground,
                borderRadius: BorderRadius.circular(20),
              ),
              child: GestureDetector(
                onTap: () {
                  MenuData data = homeController.filteredMenu[index];
                  print(data.toJson());
                  showCustomDialog(
                      context, "Addons", foodMenuBody(context, data), 200, 400);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      gridImage
                          ? Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  homeController.filteredMenu[index].image
                                      .toString(),
                                  height: Size.infinite.height,
                                  width: Size.infinite.width,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        width: 6,
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 3,
                                  height: 50,
                                  decoration:
                                      const BoxDecoration(color: primaryColor),
                                ),
                                const SizedBox(width: 5),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          homeController
                                              .filteredMenu[index].name
                                              .toString(),
                                          style: TextStyle(
                                              fontSize: fontMediumExtra,
                                              color: primaryText,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                            '${homeController.filteredMenu[index].calorie} kcal | v',
                                            style: TextStyle(
                                                color: primaryText,
                                                fontSize: fontVerySmall)),
                                      ],
                                    ),
                                  ),
                                ),
                                gridImage
                                    ? const SizedBox()
                                    : Text(
                                        homeController.filteredMenu[index].price
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: fontMediumExtra,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (AllergiesDatum item in homeController
                                    .filteredMenu[index].allergies!.data!
                                    .toList())
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: topBarIconBtn(
                                        Image.network(item.image.toString()),
                                        const Color(0xff00C4D9),
                                        0,
                                        6,
                                        16,
                                        onPressed: () {}),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Container buildTabBar() {
    return Container(
      width: double.infinity,
      height: 40,
      padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
      child: Row(
        children: [
          MaterialButton(
              elevation: 0,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              color:
                  selectedCategory == -1 ? primaryColor : secondaryBackground,
              onPressed: () {
                setState(() {
                  selectedCategory = -1;
                });
                homeController.filteredMenu.value = Utils.filterCategory(
                    homeController.menus.value, selectedCategory)!;
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Text(
                'All',
                style: TextStyle(
                    color: selectedCategory == -1 ? white : primaryText,
                    fontSize: fontMedium),
              )),
          const SizedBox(width: 15),
          Expanded(
            child: Obx(() {
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: homeController.category.value.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                    child: MaterialButton(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        color: selectedCategory == index
                            ? primaryColor
                            : secondaryBackground,
                        onPressed: () {
                          setState(() {
                            selectedCategory = index;
                          });
                          homeController.filteredMenu.value =
                              Utils.filterCategory(
                                  homeController.menus.value,
                                  homeController.category.value.data![index].id!
                                      .toInt())!;
                          // homeController
                          //     .getMenuByCategory(
                          //         id: homeController
                          //             .category
                          //             .value
                          //             .data![
                          //                 index]
                          //             .id!);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          homeController.category.value.data![index].name
                              .toString(),
                          style: TextStyle(
                              color: selectedCategory == index
                                  ? white
                                  : primaryText,
                              fontSize: fontMedium),
                        )),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Padding buildHomeTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 32,
            width: 32,
            child: IconButton(
                onPressed: () {
                  scaffoldKey.currentState!.openDrawer();
                },
                padding: EdgeInsets.zero,
                icon: Image.asset('assets/drawer.png',
                    fit: BoxFit.fitHeight, color: primaryColor)),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Text(
                    homeController.user.value.data!.name ?? '',
                    style: TextStyle(
                        fontSize: fontMediumExtra,
                        fontWeight: FontWeight.bold,
                        color: primaryText),
                  );
                }),
                Text(DateFormat('kk:mm:a | dd MMM').format(DateTime.now()),
                    style:
                        TextStyle(fontSize: fontVerySmall, color: primaryText)),
              ],
            ),
          ),
          Expanded(
            flex: 6,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Obx(
                  () => homeController.currentPage.value != 0
                      ? Container()
                      : SizedBox(
                          width: 280,
                          height: 40,
                          child: TextField(
                              onChanged: (text) async {
                                homeController.getMenuByKeyword(keyword: text);
                              },
                              keyboardType: TextInputType.text,
                              controller: textController,
                              textInputAction: TextInputAction.search,
                              style: TextStyle(
                                  fontSize: fontSmall, color: primaryText),
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
                                    onPressed: () {
                                      setState(() {
                                        textController!.text = '';
                                        homeController.getMenuByKeyword();
                                      });
                                    },
                                  ),
                                  hintText: 'Search item',
                                  hintStyle: TextStyle(
                                      fontSize: fontMedium, color: primaryText),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide.none),
                                  contentPadding: EdgeInsets.zero))),
                ),
                const SizedBox(width: 12),
                topBarIconBtn(
                    Image.asset('assets/reload.png', color: primaryColor),
                    secondaryBackground,
                    8,
                    15,
                    40, onPressed: () {
                  homeController.loadHomeData();
                  Utils.hidePopup();
                  Utils.hidePopup();
                }),
                const SizedBox(width: 12),
                Stack(
                  children: [
                    topBarIconBtn(
                        Image.asset('assets/notification.png',
                            color: primaryText),
                        secondaryBackground,
                        8,
                        15,
                        40, onPressed: () async {
                      showCustomDialog(
                          context,
                          'Accept or Cancel Online Pending Orders',
                          showNotification(),
                          160,
                          750);
                    }),
                    Positioned(
                        top: 3,
                        right: 5,
                        child: Container(
                          height: 18,
                          width: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(1),
                          child: Obx(() {
                            return Text(
                              homeController.onlineOrder.value.data!.length
                                  .toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: fontVerySmall, color: Colors.white),
                            );
                          }),
                        ))
                  ],
                ),
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
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => Home(refresh: false)));
                }),
                const SizedBox(width: 12),
                Obx(
                  () => homeController.currentPage != 0
                      ? SizedBox()
                      : topBarIconBtn(
                          Image.asset('assets/filter-alt.png',
                              color: primaryText),
                          secondaryBackground,
                          8,
                          15,
                          40, onPressed: () {
                          gridImage ? gridImage = false : gridImage = true;
                          setState(() {});
                        }),
                ),
                const SizedBox(width: 12),
                topBarIconBtn(Image.asset('assets/logout.png', color: white),
                    primaryColor, 8, 15, 40, onPressed: () {
                  showWarningDialog("Do you want to Logout from app",
                      onAccept: () async {
                    await SharedPref().saveValue('token', '');
                    await SharedPref().saveValue('loginType', '');
                    Get.offAll(Login());
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
