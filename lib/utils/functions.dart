import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:background_downloader/background_downloader.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:e_comm_user/utils/colors.dart';
import 'package:e_comm_user/utils/strings.dart';
import 'package:e_comm_user/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Functions {
  static dynamic getErrorResponse(Exception exception) {
    DioException err = exception as DioException;
    if (err.response == null) {
      return {
        'message': 'Network error or server unavailable',
        'statusCode': -1
      };
    }
    var res = err.response.toString();
    try {
      return jsonDecode(res);
    } catch (e) {
      return {
        'message': 'Error decoding response: ${e.toString()}',
        'statusCode': -1
      };
    }
  }
  static void showCustomSnackBar(
      BuildContext context, {
        required String message,
        Color backgroundColor = Colors.black87,
        Duration duration = const Duration(seconds: 2),
      }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomText(text: message,color: whiteColor,fontSize: 15.px,),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        duration: duration,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
  static String formatPrice(dynamic price) {
    final number = num.tryParse(price.toString()) ?? 0;
    return NumberFormat('#,##,##0', 'en_IN').format(number);
  }

  /// Full INR display (e.g. ₹45,999) — prices are stored as whole rupees.
  static String formatInr(dynamic price) => '₹${formatPrice(price)}';
  static void closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    } catch (e) {
      log("error");
    }
  }
  static String formatDateTime(
      String dateStr, {
        String format = 'dd MMM yyyy hh:mm:ss a',
      }) {
    try {
      final dateTime = DateTime.parse(dateStr);
      return DateFormat(format).format(dateTime);
    } catch (e) {
      return dateStr;
    }
  }
  static int getEstimatedDeliveryDays(String? input) {
    final base = DateTime.now().millisecondsSinceEpoch;

    final hash = (input ?? '').hashCode;

    // creates stable variation per product
    final value = (base + hash) % 5; // 0–4

    return 2 + value; // final range: 2 to 6 days
  }
  static double getRating(int id) {
    return 3 + (id % 3) * 0.5; // 3.0, 3.5, 4.0, 4.5
  }

  static Future<void> saveAndShareInvoice({
    required List<int> bytes,
    required int orderId,
  }) async {
    Directory dir;

    if (Platform.isAndroid) {
      dir = await getApplicationDocumentsDirectory();
    } else {
      dir = await getApplicationDocumentsDirectory();
    }

    final file = File("${dir.path}/ShopEase_Invoice_$orderId.pdf");
    await file.writeAsBytes(bytes);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(file.path)],
      )
    );
  }
  static urlLaunch(String path) async {
    if (await canLaunchUrlString(path)) {
      await launchUrlString(path, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $path';
    }
  }
  // device OS info
  static deviceOSInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.version.release;
    } else {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    }
  }
 static Future<void> downloadInvoice(
      String url,
      String fileName,
      String token,
      ) async {
    final dio = Dio();

    final dir = await getApplicationDocumentsDirectory();

    final filePath = "${dir.path}/$fileName";

    await dio.download(
      url,
      filePath,
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
        },
        responseType: ResponseType.bytes,
      ),
    );

    final file = File(filePath);

    if (await file.exists()) {
      // open file
      await OpenFile.open(file.path);
    }
  }
}
String downloadTaskPath='';
// Download file and save to device with notification, move file to download folder
extension DownloadSaveFile on dynamic{
  Future<void> downloadFileSaveStorage(BuildContext context,String fileUrl,String mobAppVersion,String savedFileName) async {
    String fileName ='$savedFileName${DateTime.now().millisecondsSinceEpoch}.pdf';
    final task = DownloadTask(
      url: fileUrl,
      filename: fileName,
      displayName: fileName,
      updates: Updates.statusAndProgress,
      requiresWiFi: false,
      retries: 5,
      allowPause: true,
    );

    Future<void> myNotificationTapCallback(Task task, NotificationType notificationType) async {
      if (mobAppVersion == '10' || Platform.isIOS){
        Functions.urlLaunch(task.url);
      }else{
        await OpenFile.open(downloadTaskPath);
      }
    }

    FileDownloader().registerCallbacks(
        taskNotificationTapCallback: myNotificationTapCallback)
        .configureNotification(
      running: TaskNotification(downloading,'file: {filename}'),
      complete: TaskNotification(fileDownLoaded,'file: {filename}'),
      error: TaskNotification(downloadFailedURL,'file: {filename}'),
      tapOpensFile: false,
      progressBar: true,
    );

    if(Platform.isIOS){
      await FileDownloader().download(task).then((value) async{
        if(value.status!=TaskStatus.complete){
          Functions.showCustomSnackBar(context,message: downloadFailedURL, backgroundColor: errorColor);
        }
      });
    }else{
      final permissionType = PermissionType.androidSharedStorage;
      var status = await FileDownloader().permissions.status(permissionType);
      if (status != PermissionStatus.granted) {
        if(await FileDownloader().permissions.shouldShowRationale(permissionType)){
          Functions.showCustomSnackBar(context,message: "$allowPermission $permissionType.", backgroundColor: primaryColor.withValues(alpha: .5));
        }
        status = await FileDownloader().permissions.request(permissionType);
        if (status == PermissionStatus.granted){
          downloadFileMove(task,context);
        }
      }else{
        downloadFileMove(task,context);
      }
    }
  }
  void downloadFileMove(DownloadTask task,BuildContext context){
    FileDownloader().download(task).then((value) async{
      if(value.status==TaskStatus.complete){
        downloadTaskPath = await FileDownloader().moveToSharedStorage(task, SharedStorage.downloads, directory: appName).then((value){
          return value.toString();
        });
        Functions.showCustomSnackBar(context,message: fileDownLoaded, backgroundColor: successColor);
      }else{
        Functions.showCustomSnackBar(context,message: downloadFailed, backgroundColor: errorColor);
      }
    });
  }
}
final addressStreamController = StreamController<String>.broadcast();
Stream<String> get deliveryAddressStream =>
    addressStreamController.stream.asBroadcastStream();