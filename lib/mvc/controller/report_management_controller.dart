

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:klio_staff/mvc/model/profit_loss_report_model.dart';
import 'package:klio_staff/mvc/model/stock_report_list_model.dart';
import 'package:klio_staff/mvc/model/waste_report_list_model.dart';
import 'package:klio_staff/service/local/shared_pref.dart';
import 'package:klio_staff/mvc/model/sale_report_list_model.dart';
import 'package:klio_staff/mvc/model/sale_report_list_model.dart' as SaleReport;
import 'package:klio_staff/mvc/model/stock_report_list_model.dart' as StockReport;
import 'package:klio_staff/mvc/model/waste_report_list_model.dart' as WasteReport;

import '../../constant/value.dart';
import '../../service/api/api_client.dart';
import '../../utils/utils.dart';
import 'error_controller.dart';

class ReportManagementController extends GetxController with ErrorController{
  Rx<SaleReportListModel> saleRepData = SaleReportListModel(data: []).obs;
  Rx<StockReportListModel> stockRepData = StockReportListModel(data: []).obs;
  Rx<ProfitLossReportModel> profitLossData =ProfitLossReportModel().obs;
  Rx<WasteReportListModel> wasteRepData = WasteReportListModel(data: []).obs;

  ///Api data fetch varriable
  int allSalePageNumber = 1;
  int stockPageNumber = 1;
  int wastePageNumber = 1;

  bool isLoadingAllSale = false;
  bool isLoadingStockReport = false;
  bool isLoadingWasteReport = false;

  bool haveMoreAllSale = true;
  bool haveMoreStockReport = true;
  bool haveMoreWasteReport = true;

  @override
  Future<void> onInit() async {
    super.onInit();
    reportDataLoading();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  Future<void> reportDataLoading()async{
    token = (await SharedPref().getValue('token'))!;
    debugPrint('checkToken\n$token');
    getSaleReportDataList();
    getStockReportDataList();
    getProfitLossReportList();
    getWasteReportDataList();
  }

  @override
  Future<void> onClose()async{}

  Future<void> getSaleReportDataList({dynamic id = ''})async{
    if (!haveMoreAllSale) {
      return;
    }
    isLoadingAllSale=true;
    String endPoint = 'report/sale?page=$allSalePageNumber';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
   var temp = saleReportListModelFromJson(response);
   List<SaleReport.Datum> datums= [];
    for (SaleReport.Datum it in temp.data!) {
      datums.add(it);
    }

    saleRepData.value.data?.addAll(datums);
    saleRepData.value.meta = temp.meta;
    allSalePageNumber++;
    if (saleRepData.value.meta!.total <= saleRepData.value.meta!.to) {
      haveMoreAllSale = false;
    }

    isLoadingAllSale = false;
    update(['saleId']);
  }

  Future<void> getStockReportDataList({dynamic id = ''})async{
    if (!haveMoreStockReport) {
      return;
    }
    isLoadingStockReport =true;
    String endPoint = 'report/stock?page=$stockPageNumber';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = stockReportListModelFromJson(response);
    List<StockReport.Datum> datums= [];
    for (StockReport.Datum it in temp.data!) {
      datums.add(it);
    }

    stockRepData.value.data?.addAll(datums);
    stockRepData.value.meta = temp.meta;
    stockPageNumber++;
    if (stockRepData.value.meta!.total <= stockRepData.value.meta!.to) {
      haveMoreStockReport = false;
    }

    isLoadingStockReport = false;
    update(['stockId']);
  }

  Future<void> getProfitLossReportList({dynamic id = ''})async{
    String endPoint = 'report/profit-loss';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    profitLossData.value = profitLossReportModelFromJson(response);
    update();
  }

  Future<void> getWasteReportDataList({dynamic id = ''})async{
    if (!haveMoreWasteReport) {
      return;
    }
    isLoadingWasteReport=true;
    String endPoint = 'report/waste?page=$wastePageNumber';
    var response = await ApiClient()
        .get(endPoint, header: Utils.apiHeader)
        .catchError(handleApiError);
    var temp = wasteReportListModelFromJson(response);
    List<WasteReport.Datum> datums= [];
    for (WasteReport.Datum it in temp.data!) {
      datums.add(it);
    }
    wasteRepData.value.data?.addAll(datums);
    wasteRepData.value.meta = temp.meta;
    wastePageNumber++;
    if (wasteRepData.value.meta!.total <= wasteRepData.value.meta!.to) {
      haveMoreWasteReport = false;
    }
    isLoadingWasteReport = false;
    update(['wasteId']);
  }


}