import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomFooterForLazyLoading extends StatelessWidget {
  const CustomFooterForLazyLoading({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        if (mode == LoadStatus.idle) {
          return renderLoadingInformation(
              AppLocalizations.of(context).lazyLoaderPullUpToLoadText);
        } else if (mode == LoadStatus.loading) {
          return renderLoadingSpinner();
        } else if (mode == LoadStatus.failed) {
          return renderLoadingInformation(
              AppLocalizations.of(context).lazyLoaderLoadFailedText);
        } else if (mode == LoadStatus.canLoading) {
          return renderLoadingInformation(
              AppLocalizations.of(context).lazyLoaderReleaseToLoadMoreText);
        } else {
          return renderLoadingInformation(
              AppLocalizations.of(context).lazyLoaderNoMoreDataText);
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
