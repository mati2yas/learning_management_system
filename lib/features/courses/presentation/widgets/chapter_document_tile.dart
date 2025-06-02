import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/utils/file_download_handler.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

class ChapterDocumentTile extends ConsumerWidget {
  final Document document;
  final Function callBack;
  const ChapterDocumentTile({
    super.key,
    required this.document,
    required this.callBack,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var textTh = Theme.of(context).textTheme;
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
        elevation: 1,
        color: mainBackgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: SizedBox(
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 15, 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 8,
                      child: Text(
                        document.title,
                        maxLines: 3,
                        style: textTh.labelMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await callBack();
                      },
                      icon: const Icon(
                        Icons.download_outlined,
                        color: Colors.green,
                      ),
                    )
                  ],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> openSecurePDF(String pdfUrl) async {
    final encryptedFilePath =
        await SecureFileHandler.downloadAndEncryptPDF(pdfUrl, "secure_file");
    return encryptedFilePath;
  }
}
