import 'package:flutter/material.dart';

class ChapterDocumentTile extends StatelessWidget {
  const ChapterDocumentTile({super.key});

  @override
  Widget build(BuildContext context) {
    var textTh = Theme.of(context).textTheme;
    return Card(
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
                      "Introduction to chemistry",
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
    );
  }
}
