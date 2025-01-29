import 'package:flutter/material.dart';
import 'package:lms_system/core/utils/file_download_handler.dart';
import 'package:lms_system/features/chapter_content/presentation/screens/chapter_document.view.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

class ChapterDocumentTile extends StatelessWidget {
  final Document document;
  const ChapterDocumentTile({
    super.key,
    required this.document,
  });
  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () async {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (context) => const ChapterDocumentView(
        //         fileUrl:
        //             "https://web.ung.edu/media/Chemistry2/Chemistry-LR.pdf"),
        //   ),
        // );
        final encryptedFilePath = await openSecurePDF("");
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                SecurePDFViewer(encryptedFilePath: encryptedFilePath),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
        elevation: 5,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: SizedBox(
          height: 55,
          child: Row(
            children: <Widget>[
              ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                  ),
                  child: SizedBox(
                    width: 55,
                    height: 55,
                    child: Image.asset(
                      "assets/images/applied_math.png",
                      fit: BoxFit.cover,
                    ),
                  )),
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
                        style: textTh.labelMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
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
