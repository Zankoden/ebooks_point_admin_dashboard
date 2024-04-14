
import 'package:ebooks_point_admin/api/api_services.dart';

class Ebook {
  int? ebookId;
  String? title;
  int? authorId;
  String? description;
  String? pdfUrl;
  int? categoryId;
  String? thumbnailUrl;
  String? uploadedDate;
  String? authorName;
  List<Reviews>? reviews;
  String? categoryName;

  Ebook(
      {this.ebookId,
      this.title,
      this.authorId,
      this.description,
      this.pdfUrl,
      this.categoryId,
      this.thumbnailUrl,
      this.uploadedDate,
      this.authorName,
      this.reviews,
      this.categoryName});

  Ebook.fromJson(Map<String, dynamic> json) {
    ebookId = json['ebook_id'];
    title = json['title'];
    authorId = json['author_id'];
    description = json['description'];
    pdfUrl = '${APIService.baseURL}/${json['pdf_url']}';
    categoryId = json['category_id'];
    thumbnailUrl = '${APIService.baseURL}/${json['thumbnail_url']}';
    uploadedDate = json['uploaded_date'];
    authorName = json['author_name'];
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews!.add(Reviews.fromJson(v));
      });
    }
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ebook_id'] = ebookId;
    data['title'] = title;
    data['author_id'] = authorId;
    data['description'] = description;
    data['pdf_url'] = pdfUrl?.replaceAll('${APIService.baseURL}/', '');
    data['category_id'] = categoryId;
    data['thumbnail_url'] =
        thumbnailUrl?.replaceAll('${APIService.baseURL}/', '');
    data['uploaded_date'] = uploadedDate;
    data['author_name'] = authorName;
    if (reviews != null) {
      data['reviews'] = reviews!.map((v) => v.toJson()).toList();
    }
    data['category_name'] = categoryName;
    return data;
  }
}

class Reviews {
  int? reviewId;
  int? userId;
  int? ebookId;
  int? rating;
  String? comment;

  Reviews(
      {this.reviewId, this.userId, this.ebookId, this.rating, this.comment});

  Reviews.fromJson(Map<String, dynamic> json) {
    reviewId = json['review_id'];
    userId = json['user_id'];
    ebookId = json['ebook_id'];
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['review_id'] = reviewId;
    data['user_id'] = userId;
    data['ebook_id'] = ebookId;
    data['rating'] = rating;
    data['comment'] = comment;
    return data;
  }
}
