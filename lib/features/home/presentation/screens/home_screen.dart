import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lms_system/core/common_widgets/async_error_widget.dart';
import 'package:lms_system/core/common_widgets/course_card_network.dart';
import 'package:lms_system/core/common_widgets/no_data_widget.dart';
import 'package:lms_system/core/constants/app_colors.dart';
import 'package:lms_system/core/constants/app_ints.dart';
import 'package:lms_system/core/utils/util_functions.dart';
import 'package:lms_system/features/courses/provider/course_content_providers.dart';
import 'package:lms_system/features/courses/provider/current_course_id.dart';
import 'package:lms_system/features/courses_filtered/providers/courses_filtered_provider.dart';
import 'package:lms_system/features/courses_filtered/providers/current_filter_provider.dart';
import 'package:lms_system/features/current_user/provider/current_user_provider.dart';
import 'package:lms_system/features/home/presentation/widgets/carousel.dart';
import 'package:lms_system/features/home/presentation/widgets/category_indicator.dart';
import 'package:lms_system/features/home/presentation/widgets/custom_home_app_bar_widget.dart';
import 'package:lms_system/features/home/provider/carousel_provider.dart';
import 'package:lms_system/features/home/provider/home_api_provider.dart';
import 'package:lms_system/features/shared/provider/course_subbed_provider.dart';
import 'package:lms_system/features/wrapper/provider/wrapper_provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //final pageviewParts = ref.watch(pageviewPartsProvider);
    var textTh = Theme.of(context).textTheme;

    var size = MediaQuery.sizeOf(context);
    bool isWideScreen = size.width > 600;

    final pageNavController = ref.read(pageNavigationProvider.notifier);

    final currentCourseFilterController =
        ref.watch(currentCourseFilterProvider.notifier);

    final homeApiState = ref.watch(homeScreenApiProvider);
    final homeApiController = ref.watch(homeScreenApiProvider.notifier);
    final currentUserState = ref.watch(currentUserProvider);
    final carouselApiState = ref.watch(carouselApiProvider);

    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: AppColors.mainBlue,
      body: SizedBox(
        height: size.height,
        child: Column(
          children: [
            CustomHomeAppBar(userState: currentUserState),
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: SizedBox(
                  width: size.width,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        spacing: 8,
                        children: [
                          const SizedBox(height: 8),
                          carouselApiState.when(
                            error: (error, stack) => Column(
                              spacing: 10,
                              children: [
                                SizedBox(
                                  height: 165,
                                  width: size.width * 0.9,
                                  child: PageView.builder(
                                    controller: pageController,
                                    itemBuilder: (_, index) {
                                      return const CarouselPage(
                                        tag: "",
                                        img: "assets/images/excelet_banner.png",
                                      );
                                    },
                                    itemCount: 2,
                                  ),
                                ),
                                SmoothPageIndicator(
                                  effect: const WormEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    strokeWidth: 2,
                                    dotColor: AppColors.darkerGrey,
                                    activeDotColor: AppColors.mainBlue,
                                  ),
                                  controller: pageController,
                                  count: 2,
                                ),
                              ],
                            ),
                            loading: () => Container(
                              height: 152,
                              width: size.width * 0.9,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.grey,
                              ),
                              alignment: Alignment.center,
                              child: const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            data: (contents) => Column(
                              spacing: 10,
                              children: [
                                SizedBox(
                                  height: 165,
                                  width: size.width * 0.9,
                                  child: contents.isEmpty
                                      ? PageView.builder(
                                          controller: pageController,
                                          itemBuilder: (_, index) {
                                            return const CarouselPage(
                                              tag: "",
                                              img:
                                                  "assets/images/excelet_banner.png",
                                            );
                                          },
                                          itemCount: 2,
                                        )
                                      : PageView.builder(
                                          controller: pageController,
                                          itemBuilder: (_, index) {
                                            return CarouselPageNetwork(
                                              tag: contents[index].tag,
                                              imgUrl: contents[index].imageUrl,
                                            );
                                          },
                                          itemCount: contents.length,
                                        ),
                                ),
                                SmoothPageIndicator(
                                  effect: const WormEffect(
                                    dotHeight: 8,
                                    dotWidth: 8,
                                    strokeWidth: 2,
                                    dotColor: AppColors.darkerGrey,
                                    activeDotColor: AppColors.mainBlue,
                                  ),
                                  controller: pageController,
                                  count: contents.isEmpty ? 2 : contents.length,
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Top Category",
                              style: textTh.titleMedium!.copyWith(
                                fontSize: isWideScreen
                                    ? (textTh.titleMedium!.fontSize! + 4)
                                    : textTh.titleMedium!.fontSize,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 90,
                            width: double.infinity,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                spacing: 8,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      currentCourseFilterController
                                          .changeFilter("lower_grades");
                                      ref
                                          .read(
                                              coursesFilteredProvider.notifier)
                                          .fetchCoursesFiltered(
                                              filter: "lower_grades");
                                      pageNavController.navigateTo(
                                        nextScreen:
                                            AppInts.coursesFilterPageIndex,
                                      );
                                    },
                                    child: CategoryIndicator(
                                      isWideScreen: isWideScreen,
                                      title: "Elementary",
                                      colorDarker: AppColors
                                          .courseCategoryColorsDarker[0],
                                      colorLighter: AppColors
                                          .courseCategoryColorsLighter[0],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      currentCourseFilterController
                                          .changeFilter("high_school");
                                      ref
                                          .read(
                                              coursesFilteredProvider.notifier)
                                          .fetchCoursesFiltered(
                                              filter: "high_school");
                                      pageNavController.navigateTo(
                                        nextScreen:
                                            AppInts.coursesFilterPageIndex,
                                      );
                                    },
                                    child: CategoryIndicator(
                                      isWideScreen: isWideScreen,
                                      title: "High School",
                                      colorDarker: AppColors
                                          .courseCategoryColorsDarker[1],
                                      colorLighter: AppColors
                                          .courseCategoryColorsLighter[1],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      currentCourseFilterController
                                          .changeFilter("university");
                                      ref
                                          .read(
                                              coursesFilteredProvider.notifier)
                                          .fetchCoursesFiltered(
                                              filter: "university");
                                      pageNavController.navigateTo(
                                        nextScreen:
                                            AppInts.coursesFilterPageIndex,
                                      );
                                    },
                                    child: CategoryIndicator(
                                      isWideScreen: isWideScreen,
                                      title: "University",
                                      colorDarker: AppColors
                                          .courseCategoryColorsDarker[2],
                                      colorLighter: AppColors
                                          .courseCategoryColorsLighter[2],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      currentCourseFilterController
                                          .changeFilter("random_courses");
                                      ref
                                          .read(
                                              coursesFilteredProvider.notifier)
                                          .fetchCoursesFiltered(
                                              filter: "random_courses");
                                      pageNavController.navigateTo(
                                        nextScreen:
                                            AppInts.coursesFilterPageIndex,
                                      );
                                    },
                                    child: CategoryIndicator(
                                      isWideScreen: isWideScreen,
                                      title: "Other Courses",
                                      colorDarker: AppColors
                                          .courseCategoryColorsDarker[3],
                                      colorLighter: AppColors
                                          .courseCategoryColorsLighter[3],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Align(
                              //   alignment: Alignment.centerLeft,
                              //   child: Text(
                              //     "Popular courses for you",
                              //     style: textTh.titleMedium!.copyWith(
                              //       fontSize: isWideScreen
                              //           ? (textTh.titleMedium!.fontSize! + 4)
                              //           : textTh.titleMedium!.fontSize,
                              //       fontWeight: FontWeight.w700,
                              //       letterSpacing: 0.7,
                              //     ),
                              //   ),
                              // ),
                              Text(
                                "Popular courses for you",
                                style: textTh.titleMedium!.copyWith(
                                  fontSize: isWideScreen
                                      ? (textTh.titleMedium!.fontSize! + 4)
                                      : textTh.titleMedium!.fontSize,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.7,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  await ref
                                      .refresh(homeScreenApiProvider.notifier)
                                      .build();
                                },
                                icon: const Icon(Icons.refresh),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          homeApiState.when(
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.mainBlue,
                                strokeWidth: 5,
                              ),
                            ),
                            error: (error, stack) => AsyncErrorWidget(
                              errorMsg: error.toString(),
                              callback: () async {
                                await ref
                                    .refresh(homeScreenApiProvider.notifier)
                                    .build();
                              },
                            ),
                            data: (courses) => courses.isEmpty
                                ? NoDataWidget(
                                    noDataMsg: "No Courses for homepage yet.",
                                    callback: () async {
                                      await ref
                                          .refresh(
                                              homeScreenApiProvider.notifier)
                                          .build();
                                    },
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    child: GridView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisExtent: 237,
                                        crossAxisCount: isWideScreen ? 3 : 2,
                                        mainAxisSpacing: 10,
                                        crossAxisSpacing: 10,
                                        childAspectRatio: UtilFunctions
                                            .getResponsiveChildAspectRatio(
                                                size),
                                      ),
                                      itemBuilder: (_, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            final courseIdController = ref
                                                .watch(currentCourseIdProvider
                                                    .notifier);
                                            courseIdController.changeCourseId(
                                                courses[index].id);

                                            ref
                                                .read(courseChaptersProvider
                                                    .notifier)
                                                .fetchCourseChapters();

                                            ref
                                                .read(courseSubTrackProvider
                                                    .notifier)
                                                .changeCurrentCourse(
                                                    courses[index]);

                                            debugPrint(
                                                "current course: Course{ id: ${ref.read(courseSubTrackProvider).id}, title: ${ref.read(courseSubTrackProvider).title} }");
                                            pageNavController.navigateTo(
                                              nextScreen: AppInts
                                                  .courseChaptersPageIndex,
                                              arguments: {
                                                "course": courses[index],
                                                "previousScreenIndex": 0,
                                              },
                                            );
                                          },
                                          child: CourseCardNetworkImage(
                                            onBookmark: () {
                                              homeApiController
                                                  .toggleSaved(courses[index]);
                                            },
                                            onLike: () {
                                              homeApiController
                                                  .toggleLiked(courses[index]);
                                            },
                                            course: courses[index],
                                            mainAxisExtent: 237,
                                          ),
                                        );
                                      },
                                      itemCount: courses.length,
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> showUserData(BuildContext context) async {
  //   var user = await SecureStorageService().getUserFromStorage();
  //   if (context.mounted) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         elevation: 5,
  //         backgroundColor: Colors.black,
  //         content: Text(
  //           "User(name: ${user?.name ?? "__"}, password: ${user?.password ?? "__"}, token: ${user?.token ?? "__"})",
  //           style: const TextStyle(color: Colors.white),
  //         ),
  //       ),
  //     );
  //   }
  // }
}
