import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showLoading(BuildContext context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Row(
            children: [
              Text("Loading..."),
              Spacer(),
              CircularProgressIndicator(),
            ],
          ),
        );
      });
}

showMessage(BuildContext context,
    {String? title,
    String? content,
    String? posButtonTitle,
    Function? onPosButtonClick,
    String? negButtonTitle,
    Function? onNegButtonClick}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return CupertinoAlertDialog(
          title: title != null ? Text(title) : null,
          content: content != null ? Text(content) : null,
          actions: [
            if (posButtonTitle != null)
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onPosButtonClick != null){
                      onPosButtonClick();
                    }
                  },
                  child: Text(posButtonTitle)),
            if (negButtonTitle != null)
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (onNegButtonClick != null) onNegButtonClick();
                  },
                  child: Text(negButtonTitle)),
          ],
        );
      });
}
