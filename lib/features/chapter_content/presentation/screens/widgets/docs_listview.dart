import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/constants/colors.dart';
import 'package:lms_system/features/courses/presentation/widgets/chapter_document_tile.dart';
import 'package:lms_system/features/document_viewer/model/document_status.dart';
import 'package:lms_system/features/document_viewer/presentation/screens/document_viewer_screen.dart';
import 'package:lms_system/features/document_viewer/provider/document_viewer_provider.dart';
import 'package:lms_system/features/shared/model/chapter.dart';

class DocumentsListView extends ConsumerWidget {
  final List<Document> documents;
  const DocumentsListView({
    super.key,
    required this.documents,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: documents.length,
      itemBuilder: (context, index) => ChapterDocumentTile(
        document: documents[index],
        callBack: () async {
          var docProcessor = ref.read(documentProvider.notifier);
          const urll =
              "https://www.cs.umd.edu/~atif/Teaching/Spring2011/Slides/8.pdf";

          await docProcessor.processPDF(urll, documents[index].title);

          if (context.mounted) {
            if (ref.read(documentProvider).status ==
                DocumentStatus.downloading) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Container(
                    color: Colors.white,
                    width: 120,
                    height: 150,
                    child: const Column(
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.mainBlue,
                        ),
                        Text("Downloading File:"),
                      ],
                    ),
                  ),
                ),
              );
            }
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const SecurePDFViewer(),
              ),
            );
          }
        },
      ),
    );
  }
}
