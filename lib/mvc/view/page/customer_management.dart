import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/color.dart';
import '../../../constant/value.dart';
import '../../controller/customer_management_controller.dart';
import '../dialog/custom_dialog.dart';
import '../widget/custom_widget.dart';

class CustomerManagement extends StatefulWidget {
  const CustomerManagement({Key? key}) : super(key: key);

  @override
  State<CustomerManagement> createState() => _CustomerManagementState();
}

class _CustomerManagementState extends State<CustomerManagement> with SingleTickerProviderStateMixin {
  CustomerController cusController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              children: [
                itemHeaderTitle(),
                Expanded(child: customerDataTable()),
              ],
            )));
  }
  itemHeaderTitle() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text(
              'Customer List',
              style: TextStyle(fontSize: fontBig, color: primaryText),
            ),
          ),
          Container(
            margin: EdgeInsets.only(right: 25),
            child: Row(
              children: [
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.add,
                    color: primaryText,
                  ),
                  label: Text(
                    "Add New Customer",
                    style: TextStyle(
                      color: primaryText,
                    ),
                  ),
                  onPressed: () {
                    showCustomDialog(context, "Add New Customer",
                        addNewCustomer(), 30, 400);
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.0, color: primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget customerDataTable() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: secondaryBackground,
        child: SingleChildScrollView(
            child: GetBuilder<CustomerController>(builder: (customerController) {
              return DataTable(
                dataRowHeight: 70,
                columns:
                [
                  DataColumn(
                    label: Text(
                      'SL NO',
                      style: TextStyle(color: textSecondary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(color: textSecondary),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Action',
                      style: TextStyle(color: textSecondary),
                    ),
                  )
                ],
                //rows: [],

                rows: customerController.customerData.value.data!.reversed
                    .map((item)=>DataRow(
                    cells: [
                      DataCell(
                          Text('${item.id ?? ""}',
                            style: TextStyle(color: primaryText),
                          )
                      ),
                      DataCell(
                          Text('${item.name ?? ""}',
                            style: TextStyle(color: primaryText),
                          )
                      ),
                      DataCell(
                        Row(
                          children:[
                            Container(
                              height: 35,
                              width:35,
                              decoration: BoxDecoration(
                                color:Color(0xffFFE7E6),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  cusController.getSingleCustomerDetails(item.id)
                                  .then((value) {
                                    showCustomDialog(context, 'View Customer Details',
                                        viewCustomer(), 100, 300);
                                  });
                                },
                                child: Image.asset(
                                  "assets/hide.png",
                                  height: 15,
                                  width: 15,
                                  color: Color(0xff00A600),
                                ),
                              ),
                            ),
                            SizedBox(width: 40),
                            Container(
                              height: 35,
                              width:35,
                              decoration: BoxDecoration(
                                color:Color(0xffFFE7E6),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  showWarningDialog("Do you wan to delete this item?",
                                      onAccept: () async {
                                        cusController.deleteCustomerData(id: item.id);
                                        Get.back();
                                      }
                                  );
                                },
                                child: Image.asset(
                                  "assets/delete.png",
                                  height: 15,
                                  width: 15,
                                  color: Color(0xffED0206),
                                ),
                              ),
                            ),
                          ]
                        ),
                      )
                    ])) .toList(),

              );
            })),
      ),
    );
  }

  Widget addNewCustomer() {
    return
      Container(
          height: Size.infinite.height,
          width: Size.infinite.width,
          padding: EdgeInsets.all(30),
          child: Form(
            key: cusController.uploadCustomerFormKey,
            child: ListView(children: [
              textRow('First Name', 'Last Name'),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                    height:52,
                    child: TextFormField(
                         controller: cusController.fNameCtlr,
                        validator: cusController.textValidator,
                        decoration: InputDecoration(
                          fillColor: secondaryBackground,
                          hintText: 'Enter First Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          hintStyle:
                          TextStyle(fontSize: fontVerySmall, color: textSecondary),

                        ),keyboardType: TextInputType.text),
                  ),),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height:52,
                      child: TextFormField(
                          controller: cusController.lNameCtlr,
                          validator: cusController.textValidator,
                          decoration: InputDecoration(
                            fillColor: secondaryBackground,
                            hintText: 'Enter Last Name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintStyle:
                            TextStyle(fontSize: fontVerySmall, color: textSecondary),

                          ),keyboardType: TextInputType.text),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              textRow('Email', 'Phone'),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height:52,
                      child: TextFormField(
                          controller: cusController.emailCtlr,
                          validator: cusController.textValidator,
                          decoration: InputDecoration(
                            fillColor: secondaryBackground,
                            hintText: 'Enter Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintStyle:
                            TextStyle(fontSize: fontVerySmall, color: textSecondary),

                          ),keyboardType: TextInputType.emailAddress),
                    ),),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height:52,
                      child: TextFormField(
                          controller: cusController.phoneCtlr,
                          validator: cusController.textValidator,
                          decoration: InputDecoration(
                            fillColor: secondaryBackground,
                            hintText: 'Enter Phone Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintStyle:
                            TextStyle(fontSize: fontVerySmall, color: textSecondary),

                          ),keyboardType: TextInputType.number),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              textRow('Delivery Address', ''),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height:52,
                      child: TextFormField(
                          controller: cusController.addressCtlr,
                          validator: cusController.textValidator,
                          decoration: InputDecoration(
                            fillColor: secondaryBackground,
                            hintText: 'Enter Delivery Address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            hintStyle:
                            TextStyle(fontSize: fontVerySmall, color: textSecondary),

                          ),keyboardType: TextInputType.text),
                    ),),
                  SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height:52,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    normalButton('Submit', primaryColor, white, onPressed: (){
                      if(cusController.uploadCustomerFormKey.currentState!.validate()){
                        cusController.addNewCustomer(
                            cusController.fNameCtlr.text,
                            cusController.lNameCtlr.text,
                            cusController.emailCtlr.text,
                            cusController.phoneCtlr.text,
                            cusController.addressCtlr.text,
                        );
                        cusController.fNameCtlr.clear();
                        cusController.lNameCtlr.clear();
                        cusController.emailCtlr.clear();
                        cusController.phoneCtlr.clear();
                        cusController.addressCtlr.clear();
                      }
                    }),
                  ],
                )
            ]),
          ),
    );
  }

  Widget viewCustomer() {
    return Container(
      padding: EdgeInsets.only(left: 40, right: 15),
      child: ListView(
        children: [
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Name:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.name.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Email:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.email.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Phone:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.phone.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Delivery Address:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.deliveryAddress.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Number of Visit:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.noOfVisit.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Last Visit:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.lastVisit.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Point Acquired:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.pointsAcquired.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
            child: Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: Text(
                        'Used Points:',
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                    flex: 7,
                    child: Container(
                      child: Text(
                        cusController.singleCustomerData.value.data!.usedPoints.toString(),
                        style: TextStyle(
                            fontSize: fontVerySmall,
                            color: primaryText,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ],
            ),
          ),
          SizedBox(height:10),
          SizedBox(
            height: 40,
          ),
        ],
      ),
    );
  }


}
