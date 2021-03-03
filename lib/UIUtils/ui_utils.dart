import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lyrics_track/UIUtils/reachability.dart';

typedef AlertWidgetButtonActionCallback = void Function(int index);


class UIUtils {
  factory UIUtils() {
    return _singleton;
  }


  static final UIUtils _singleton = UIUtils._internal();


  UIUtils._internal() {
    print("Instance created UIUtills");
    initConnectivity();
  }
  Future<void> initConnectivity() async {
    /// Wait until setup reachability
    Reachability reachability = Reachability();
    await reachability.setUpConnectivity();
    print("Network status : ${reachability.connectStatus}");
  }


  //region Screen Size and Proportional according to device
  double _screenHeight;
  double _screenWidth;

  double get screenHeight => _screenHeight ?? _referenceScreenHeight;

  double get screenWidth => _screenWidth ?? _referenceScreenWidth;

  final double _referenceScreenHeight = 812;
  final double _referenceScreenWidth = 375;

  void updateScreenDimension({double width, double height}) {
    if (_screenWidth != null && _screenHeight != null) {
      return;
    }

    print("Update Screen Dimension");

    _screenWidth = (width != null) ? width : _screenWidth;
    _screenHeight = (height != null) ? height : _screenHeight;
  }

  double getProportionalHeight(double height) {
    if (_screenHeight == null) return height;
    final h = _screenHeight * height / _referenceScreenHeight;
    return h.floorToDouble();
  }

  double getProportionalWidth(double width) {
    if (_screenWidth == null) return width;
    final w = _screenWidth * width / _referenceScreenWidth;
    return w.floorToDouble();
  }

  //endregion


  static void showProgressDialog(BuildContext context) {
    print("DisPlay Loader");
    showDialog(
        barrierDismissible: false,
        context: context,
        // barrierColor: Colors.transparent,
        builder: (_) => LoadMoreWidget());
  }


  static bool isInternetAvailable(GlobalKey<ScaffoldState> key,
      {bool isInternetMessageRequire = true}) {
    bool isInternet = Reachability().isInterNetAvaialble();
    if (!isInternet && isInternetMessageRequire) {
      UIUtils.showSnackBar(
          key, "No internet Available");
    }
    return isInternet;
  }

  static void showSnackBar(GlobalKey<ScaffoldState> _key, String message,
      {int duration = 1, SnackBarAction action}) {
    if ((message ?? '').isEmpty) {
      return;
    }
    final text = Text(
      message,
      style: UIUtils().getTextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 14,
        color: Colors.white,
      ),
    );

    final snackBar = SnackBar(
      content: text,
      backgroundColor: Colors.black,
      duration: Duration(seconds: duration),
      action: action,
    );

    // Remove Current sanckbar if viewed
    _key.currentState.removeCurrentSnackBar();
    _key.currentState.showSnackBar(snackBar);
  }



  static Future dismissProgressDialog(BuildContext context) async {
    /// This Delay Added due to loader open or not
    await Future.delayed(Duration(milliseconds: 100));
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    return null;
  }


  TextStyle getTextStyle(
      {String fontFamily,
        int fontSize,
        Color color,
        List<Shadow> shadow,
        TextDecoration decoration,
        FontWeight fontWeight,
        bool isFixed = false,
        double characterSpacing,
        double wordSpacing,
        double lineSpacing}) {
    double finalFontSize = (fontSize ?? 12).toDouble();

    if (!isFixed && this._screenWidth != null) {
      finalFontSize = (finalFontSize * _screenWidth) / _referenceScreenWidth;
    }
    return TextStyle(
        fontSize: finalFontSize,
        // fontFamily: fontFamily ?? AppFont.sfProText,
        fontWeight: fontWeight ?? FontWeight.w400,
        color: color,
        decoration: decoration ?? TextDecoration.none,
        letterSpacing: characterSpacing,
        wordSpacing: wordSpacing,
        height: lineSpacing,
        shadows: shadow
    );
  }

  static bool isPasswordCompliant(String password, [int minLength = 5]) {
    if (password == null || password.isEmpty) {
      return false;
    }

    bool hasUppercase = password.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = password.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = password.contains(new RegExp(r'[a-z]'));
    bool hasSpecialCharacters =
    password.contains(new RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasMinLength = password.length > minLength;

    return (hasDigits &
    hasUppercase &
    hasLowercase &
    hasSpecialCharacters &
    hasMinLength);
  }

  // Tuple2<String, bool> checkInternetConnection() {
  //   if (!Reachability().isInterNetAvaialble()) {
  //     return Tuple2(Translations.current.msgInternetMessage, false);
  //   } else {
  //     return Tuple2('', true);
  //   }
  // }

  // bool checkInternetConnectionFromScreen(
  //     {GlobalKey<ScaffoldState> scaffoldKey}) {
  //   var result = UIUtils().checkInternetConnection();
  //   if (!result.item2) {
  //     Utils.showSnackBar(scaffoldKey, result.item1);
  //     return result.item2;
  //   } else {
  //     return true;
  //   }
  // }

  // Future<void> showProgressDialog(BuildContext context) {
  //   Logger().v("DisPlay Loader");
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (_) => ProgressDiloag());
  // }

  // Future<void> dismissProgressDialog(BuildContext context) {
  //   if (Navigator.of(context).canPop()) {
  //     Navigator.of(context).pop();
  //   }
  // }



  Widget buildForValidaionMessage1(
      {String message, Color textcolor = Colors.redAccent, double height = 0}) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: height,),
      child: Container(
        padding: EdgeInsets.only(left: 24.0, top: 3.0),
        child: Visibility(
          visible: message.length > 0,
          child: Text(
            message,
            // style: UIUtils().getTextStyle(
            //     fontFamily: AppFont.sfProText,
            //     fontWeight: FontWeight.w400,
            //     fontSize: 12,
            //     color: Colors.redAccent),
          ),
        ),
      ),
    );
  }

}


class LoadMoreWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: UIUtils().getProportionalWidth(30),
        width: UIUtils().getProportionalWidth(30),
        margin: EdgeInsets.only(
          bottom: UIUtils().getProportionalWidth(10),
        ),
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      ),
    );
  }
}
