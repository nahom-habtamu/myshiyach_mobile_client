import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CustomFooterForLazyLoading extends StatelessWidget {
  const CustomFooterForLazyLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        if (mode == LoadStatus.idle) {
          return renderLoadingInformation("Pull up load");
        } else if (mode == LoadStatus.loading) {
          return renderLoadingSpinner();
        } else if (mode == LoadStatus.failed) {
          return renderLoadingInformation("Load Failed! Click retry!");
        } else if (mode == LoadStatus.canLoading) {
          return renderLoadingInformation("Release to load more");
        } else {
          return renderLoadingInformation("No more Data");
        }
      },
    );
  }

  Widget renderLoadingInformation(String text) {
    return SizedBox(
      height: 55.0,
      child: Center(child: Text(text)),
    );
  }

  Widget renderLoadingSpinner() {
    return const SizedBox(
      height: 55.0,
      child: Center(child: CupertinoActivityIndicator()),
    );
  }
}
