import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instagram_clone/util/Color.dart';

import '../Model/post_model.dart';
import '../Model/story_model.dart';
import '../provider/post_provider.dart';

final isTappedProvider = StateProvider<bool>((ref) => false);
final currentIndexProvider = StateProvider<int>((ref) => 0);
final imageDoubleTapProvider = StateProvider<bool>((ref) => false);
final scaleProvider = StateProvider<double>((ref) => 0.0);
final List<StoryModel> storyModel = [
  StoryModel(id: "hangang", image: "", isOther: false),
  StoryModel(id: "hangang2", image: "", isOther: true),
  StoryModel(id: "hangang3", image: "", isOther: true),
  StoryModel(id: "hangang4", image: "", isOther: true),
  StoryModel(id: "hangang5", image: "", isOther: true),
  StoryModel(id: "hangang6", image: "", isOther: true),
  StoryModel(id: "hangang7", image: "", isOther: true),
  StoryModel(id: "hangang8", image: "", isOther: true),
  StoryModel(id: "hangang9", image: "", isOther: true),
  StoryModel(id: "hangang10", image: "", isOther: true),
  StoryModel(id: "hangang11", image: "", isOther: true),
  StoryModel(id: "hangang12", image: "", isOther: true),
  StoryModel(id: "hangang13", image: "", isOther: true),
  StoryModel(id: "hangang14", image: "", isOther: true),
  StoryModel(id: "hangang15", image: "", isOther: true),
  StoryModel(id: "hangang16", image: "", isOther: true),
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.black,
      body: SafeArea(
          child: Column(
        children: [
          const TitleWidget(),
          const StoryWidget(),
          Container(
            width: 1.sw,
            height: 0.08.h,
            color: Colors.white,
          ),
          const PostWidget()
        ],
      )),
    );
  }
}

class PostWidget extends ConsumerWidget {
  const PostWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);

    if (posts.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Expanded(
        child: ListView.separated(
          itemCount: posts.length,
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          itemBuilder: (context, index) {
            return PostItemWidget(currentIndex: index);
          },
          separatorBuilder: (context, index) {
            return SizedBox(
              height: 10.h,
            );
          },
        ),
      );
    }
  }
}

class PostItemWidget extends ConsumerWidget {
  final int currentIndex;

  const PostItemWidget({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(postsProvider);
    final post = posts[currentIndex];

    return Column(
      children: [
        postTitleWidget(context, post, currentIndex, ref),
        Container(
          margin: EdgeInsets.only(top: 10.h),
          width: double.infinity,
          color: Colors.grey,
          child: Stack(
            alignment: Alignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  ref.read(postsProvider.notifier).setLike(currentIndex);

                  if (!post.like) {
                    ref.read(postsProvider.notifier).setScale(currentIndex, 10.0);
                    Future.delayed(const Duration(milliseconds: 500)).then(
                        (value) => ref.read(postsProvider.notifier).setScale(currentIndex, 0.0));
                  } else {
                  }
                },
                child: Image.network(
                  post.image,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child; // 이미지 로딩이 완료된 경우 원본 이미지를 반환
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 5,
                        ),
                      );
                    }
                  },
                ),
              ),
              AnimatedScale(
                  scale: post.scale,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                  child: Icon(
                    Icons.favorite_rounded,
                    color: Colors.white.withOpacity(0.8),
                    size: 100,
                  ))
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      ref.read(postsProvider.notifier).setLike(currentIndex);
                    },
                    iconSize: 20.w,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      switch (post.like) {
                        true => Icons.favorite,
                        false => Icons.favorite_outline
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  IconButton(
                    onPressed: () {},
                    iconSize: 20.w,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.chat_bubble_outline_outlined,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  IconButton(
                    onPressed: () {},
                    iconSize: 20.w,
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    icon: Transform.rotate(
                      angle: 150,
                      child: const Icon(
                        Icons.send_rounded,
                      ),
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  ref.read(postsProvider.notifier).setBookMark(currentIndex);
                },
                iconSize: 20.w,
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: Icon(
                  switch (post.bookmark) {
                    true => Icons.bookmark,
                    false => Icons.bookmark_outline
                  },
                ),
              ),
            ],
          ),
        ),
        if (post.favorite!.isNotEmpty)
          Container(
              margin: EdgeInsets.only(bottom: 2.h),
              alignment: Alignment.centerLeft,
              child: Text(
                switch (post.favorite?.length) {
                  1 => '${post.favorite![0]}님이 좋아합니다.',
                  0 => '',
                  _ => '${post.favorite![0]}님 외 여러명이 좋아합니다.'
                },
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white),
              )),
        Container(
            margin: EdgeInsets.only(bottom: 6.h, top: 4.h),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Text(
                  post.id,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w900,
                      color: Colors.white),
                ),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  post.content,
                  style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white),
                ),
              ],
            )),
        if (post.comment!.isNotEmpty)
          Container(
              margin: EdgeInsets.only(bottom: 2.h),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    post.comment![0].commentId,
                    style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.white),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 6.w),
                    child: Text(
                      post.comment![0].commentText,
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white),
                    ),
                  ),
                ],
              )),
        if (post.comment!.length > 1)
          Visibility(
            visible: !posts[currentIndex].commentVisible,
            child: GestureDetector(
              onTap: () {
                ref
                    .read(postsProvider.notifier)
                    .setCommentVisible(currentIndex);
              },
              child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 6.w),
                        child: Text(
                          '.... 더 보기',
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
        Visibility(
          visible: posts[currentIndex].commentVisible,
          child: Column(
            children: [
              for (int i = 1; i < post.comment!.length; i++)
                Container(
                    margin: EdgeInsets.only(bottom: 2.h),
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          post.comment![i].commentId,
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 6.w),
                          child: Text(
                            post.comment![i].commentText,
                            style: TextStyle(
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ],
                    )),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            children: [
              for (var i = 0; i < post.tag.length; i++)
                Container(
                  margin: EdgeInsets.only(right: 4.w),
                  child: Text(
                    '#${post.tag[i]}',
                    style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.tealAccent.withOpacity(0.6)),
                  ),
                ),
            ],
          ),
        )
      ],
    );
  }

  Row postTitleWidget(
      BuildContext context, Post post, int currentIndex, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 36.w,
              height: 36.w,
              margin: EdgeInsets.only(right: 10.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorSet.borderGradient2,
                    ColorSet.borderGradient3,
                    ColorSet.borderGradient4,
                  ],
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3.w),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 8.w),
              child: Text(
                post.id,
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
            ),
            if (currentIndex % 2 == 0)
              Container(
                width: 10.w,
                height: 10.w,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: Icon(
                  Icons.check,
                  size: 8.w,
                  color: Colors.black,
                ),
              )
          ],
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            showBtmSheet(context, post, currentIndex, ref);
          },
          icon: const Icon(Icons.more_vert),
          iconSize: 20.w,
          splashColor: Colors.transparent,
          alignment: Alignment.centerRight,
        )
      ],
    );
  }

  Future<dynamic> showBtmSheet(
      BuildContext context, Post post, int currentIndex, WidgetRef ref) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: false,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.h))),
      builder: (context) {
        return Wrap(
          children: [
            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 0.5.sw,
                          child: BtmSheetIconWidget(
                            icon: switch (post.bookmark) {
                              true => Icons.bookmark,
                              false => Icons.bookmark_outline
                            },
                            title: '저장',
                            function: () {
                              ref
                                  .read(postsProvider.notifier)
                                  .setBookMark(currentIndex);
                              context.pop();
                            },
                          )),
                      SizedBox(
                          width: 0.5.sw,
                          child: BtmSheetIconWidget(
                            icon: Icons.qr_code_scanner_outlined,
                            title: 'QR 코드',
                            function: () {
                              context.pop();
                            },
                          )),
                    ],
                  ),
                ),
                Container(
                  width: 1.sw,
                  height: 0.08.h,
                  color: Colors.white,
                ),
                const BtmSheetItemWidget(
                  icon: Icons.star_border_outlined,
                  text: '즐겨찾기 추가',
                  isComplaint: false,
                ),
                const BtmSheetItemWidget(
                  icon: Icons.person_remove_alt_1_outlined,
                  text: '팔로우 취소',
                  isComplaint: false,
                ),
                Container(
                  width: 1.sw,
                  height: 0.08.h,
                  color: Colors.white,
                ),
                const BtmSheetItemWidget(
                  icon: Icons.info_outline_rounded,
                  text: '이 게시물이 표시되는 이유',
                  isComplaint: false,
                ),
                const BtmSheetItemWidget(
                  icon: Icons.visibility_off_outlined,
                  text: '숨기기',
                  isComplaint: false,
                ),
                const BtmSheetItemWidget(
                  icon: Icons.account_circle_outlined,
                  text: '이 계정 점보',
                  isComplaint: false,
                ),
                const BtmSheetItemWidget(
                  icon: Icons.announcement_outlined,
                  text: '신고',
                  isComplaint: true,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class BtmSheetItemWidget extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isComplaint;

  const BtmSheetItemWidget({
    super.key,
    required this.icon,
    required this.text,
    required this.isComplaint,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        padding: EdgeInsets.all(10.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20.w,
              color: isComplaint ? Colors.red : null,
            ),
            SizedBox(
              width: 6.w,
            ),
            Text(
              text,
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: isComplaint ? Colors.red : Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

class BtmSheetIconWidget extends StatelessWidget {
  const BtmSheetIconWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.function});

  final IconData icon;
  final String title;
  final Function function;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            margin: EdgeInsets.only(bottom: 6.h),
            decoration: BoxDecoration(
                border: Border.all(width: 1.w, color: Colors.white),
                shape: BoxShape.circle),
            child: Icon(icon),
          ),
          Text(
            title,
            style: TextStyle(fontSize: 10.sp, color: Colors.white),
          )
        ],
      ),
    );
  }
}

class StoryWidget extends ConsumerWidget {
  const StoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      height: 66.h,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        separatorBuilder: (context, index) {
          return SizedBox(
            width: 12.w,
          );
        },
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: storyModel.length,
        itemBuilder: (context, index) {
          var isTapped = ref.watch(isTappedProvider);
          var currentIndex = ref.watch(currentIndexProvider);
          return StoryItem(
              listIndex: index,
              isTapped: isTapped,
              currentIndex: currentIndex,
              storyModel: storyModel);
        },
      ),
    );
  }
}

class StoryItem extends ConsumerWidget {
  const StoryItem({
    super.key,
    required this.isTapped,
    required this.currentIndex,
    required this.storyModel,
    required this.listIndex,
  });

  final bool isTapped;
  final int currentIndex;
  final List<StoryModel> storyModel;
  final int listIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(isTappedProvider.notifier).state = true;
        ref.read(currentIndexProvider.notifier).state = listIndex;
        Future.delayed(const Duration(milliseconds: 400))
            .then((value) => ref.read(isTappedProvider.notifier).state = false);
      },
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 4.h),
                child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: isTapped && currentIndex == listIndex ? 46.w : 50.w,
                    height: isTapped && currentIndex == listIndex ? 46.w : 50.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        gradient: switch (storyModel[listIndex].isOther) {
                          true => const LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                ColorSet.borderGradient2,
                                ColorSet.borderGradient3,
                                ColorSet.borderGradient4,
                              ],
                            ),
                          false => null
                        }),
                    alignment: Alignment.center,
                    child: switch (storyModel[listIndex].isOther) {
                      true => Container(
                          width: isTapped && currentIndex == listIndex
                              ? 42.w
                              : 46.w,
                          height: isTapped && currentIndex == listIndex
                              ? 42.w
                              : 46.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 3.w),
                            shape: BoxShape.circle,
                          ),
                        ),
                      _ => null
                    }),
              ),
              if (!storyModel[listIndex].isOther)
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h, right: 2.w),
                  child: Container(
                    width: 16.w,
                    height: 16.w,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        border: Border.all(color: Colors.black, width: 1.5.w)),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 12.w,
                    ),
                  ),
                )
            ],
          ),
          Text(
            storyModel[listIndex].id,
            style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white),
          )
        ],
      ),
    );
  }
}

class TitleWidget extends StatelessWidget {
  const TitleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w, right: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Instagram',
            style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () {},
                iconSize: 24.w,
                icon: const Icon(Icons.favorite_outline),
              ),
              SizedBox(
                width: 0.w,
              ),
              IconButton(
                onPressed: () {},
                iconSize: 24.w,
                icon: Transform.rotate(
                  angle: 150,
                  child: const Icon(
                    Icons.send_rounded,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
