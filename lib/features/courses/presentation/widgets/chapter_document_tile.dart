import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lms_system/core/constants/colors.dart';

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
        height: 100,
        child: Row(
          children: <Widget>[
            ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0),
                ),
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset(
                    "assets/images/applied_math.png",
                    fit: BoxFit.cover,
                  ),
                )),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(6.0, 10.0, 15, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 8,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Chapter 1",
                          style: textTh.labelLarge!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          "Introduction to chemistry",
                          style: textTh.labelMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/topics.svg",
                              width: 12,
                              height: 12,
                              colorFilter: const ColorFilter.mode(
                                AppColors.mainBlue,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              "125 Pages",
                              style: textTh.labelMedium!.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppColors.mainBlue,
                          child: Center(
                            child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.download_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
