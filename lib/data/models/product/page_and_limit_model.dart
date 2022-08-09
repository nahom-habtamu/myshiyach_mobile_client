import '../../../core/constants/lazy_loading_constants.dart';
import '../../../domain/enitites/page_and_limit.dart';

class PageAndLimitModel extends PageAndLimit {
  PageAndLimitModel({
    required int limit,
    required int page,
  }) : super(limit: limit, page: page);

  factory PageAndLimitModel.fromJson(dynamic json) {
    return PageAndLimitModel(
      limit: json["limit"],
      page: json["page"],
    );
  }

  factory PageAndLimitModel.initialDefault() {
    return PageAndLimitModel(
      limit: lazyLoadingLimit,
      page: 1,
    );
  }

  static PageAndLimitModel? fromPaginationLimit(PageAndLimit? pageAndLimit) {
    return pageAndLimit == null
        ? null
        : PageAndLimitModel(
            limit: pageAndLimit.limit,
            page: pageAndLimit.page,
          );
  }
}
