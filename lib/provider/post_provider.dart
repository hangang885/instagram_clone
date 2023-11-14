import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../Model/post_model.dart';

final postsProvider = StateNotifierProvider<PostStateNotifier, List<Post>>(
    (ref) => PostStateNotifier());

class PostStateNotifier extends StateNotifier<List<Post>> {
  PostStateNotifier() : super([]) {
    getPost();
  }

  final collection = FirebaseFirestore.instance.collection('Post');

  Future<void> getPost() async {
    QuerySnapshot<Map<String, dynamic>> _snapshot =
        await collection.orderBy('id').get();
    state = _snapshot.docs.map((e) => Post.fromJson(e.data())).toList();
  }

  setCommentVisible(index) {
    state = List.from(state)
      ..[index] =
          state[index].copyWith(commentVisible: !state[index].commentVisible);
  }

  getDocumentId(filed) async {
    // 컬렉션에 대한 쿼리 수행
    QuerySnapshot querySnapshot = await collection.get();

// 일치하는 문서 ID 목록
    String matchingDocumentId = "";

    querySnapshot.docs.forEach((doc) {
      // 문서의 데이터 가져오기
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // 특정 필드 값 가져오기 (예: 'fieldName')
      dynamic fieldValue = data['id']; // 필드 이름 대신 원하는 필드명 사용

      // 필드 값이 목표 값과 일치하는 경우 해당 문서 ID를 목록에 추가
      if (fieldValue == filed) {
        matchingDocumentId = doc.id;
      }
    });
    return matchingDocumentId;
  }

  setLike(index) async {
    state = List.from(state)
      ..[index] = state[index].copyWith(like: !state[index].like);
    collection
        .doc(await getDocumentId(state[index].id))
        .update(state[index].toMap());
  }

  setBookMark(index) async {
    state = List.from(state)
      ..[index] = state[index].copyWith(bookmark: !state[index].bookmark);
    collection
        .doc(await getDocumentId(state[index].id))
        .update(state[index].toMap());
  }
  setScale(index, scale) async {
    state = List.from(state)
      ..[index] = state[index].copyWith(scale: scale);
    collection
        .doc(await getDocumentId(state[index].id))
        .update(state[index].toMap());
  }
}


