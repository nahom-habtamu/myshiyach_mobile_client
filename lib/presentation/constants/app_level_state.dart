import 'package:flutter_bloc/src/bloc_provider.dart';

import '../../core/services/injection_container.dart';
import '../bloc/add_message_to_conversation/add_message_to_conversation_cubit.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/authenticate_phone_number/authenticate_phone_number.cubit.dart';
import '../bloc/change_language/change_language_cubit.dart';
import '../bloc/change_password/change_password_cubit.dart';
import '../bloc/create_product/create_product_cubit.dart';
import '../bloc/delete_product_by_id/delete_product_by_id_cubit.dart';
import '../bloc/display_all_products/display_all_products_cubit.dart';
import '../bloc/filter/filter_products_cubit.dart';
import '../bloc/get_all_categories/get_all_categories_cubit.dart';
import '../bloc/get_all_conversations/get_all_conversations_cubit.dart';
import '../bloc/get_all_products/get_all_products_cubit.dart';
import '../bloc/get_conversation_by_id.dart/get_conversation_by_id_cubit.dart';
import '../bloc/get_data_needed_to_manage_post/get_data_needed_to_manage_post_cubit.dart';
import '../bloc/get_favorite_products/get_favorite_products_cubit.dart';
import '../bloc/get_post_detail_content/get_post_detail_content_cubit.dart';
import '../bloc/get_products_by_user_id/get_products_by_user_id_cubit.dart';
import '../bloc/get_user_by_id/get_user_by_id_cubit.dart';
import '../bloc/handle_going_to_message/handle_going_to_message_cubit.dart';
import '../bloc/logout/logout_cubit.dart';
import '../bloc/mark_messages_as_read/mark_messages_as_read_cubit.dart';
import '../bloc/refresh_product/refresh_product_cubit.dart';
import '../bloc/register_user/register_user_cubit.dart';
import '../bloc/set_favorite_products/set_favorite_products_cubit.dart';
import '../bloc/update_product/update_product_cubit.dart';
import '../bloc/verify_phone_number/verify_phone_number_cubit.dart';

class AppLevelState {
  static List<BlocProviderSingleChildWidget> get() {
    return [
      BlocProvider(
        create: (_) => sl<AuthCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<VerifyPhoneNumberCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<RegisterUserCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<DisplayAllProductsCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetAllProductsCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetFavoriteProductsCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<SetFavoriteProductsCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetDataNeededToManagePostCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<CreateProductCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetAllConversationsCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetConversationByIdCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetUserByIdCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<AddMessageToConversationCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<DeleteProductByIdCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<HandleGoingToMessageCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetAllCategoriesCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<UpdateProductCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<LogOutCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetProductsByUserIdCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<AuthPhoneNumberCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<ChangePasswordCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<FilterProductsCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<RefreshProductCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<ChangeLanguageCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<MarkMessagesAsReadCubit>(),
      ),
      BlocProvider(
        create: (_) => sl<GetPostDetailContentCubit>(),
      )
    ];
  }
}
