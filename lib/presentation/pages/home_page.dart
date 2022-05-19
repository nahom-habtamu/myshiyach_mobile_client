import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/enitites/product.dart';
import '../bloc/get_all_products/get_all_products_cubit.dart';
import '../bloc/get_all_products/get_all_products_state.dart';

class HomePage extends StatefulWidget {
  static String routeName = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      context.read<GetAllProductsCubit>().execute();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<GetAllProductsCubit, GetAllProductsState>(
          builder: (context, state) {
            if (state is Loaded) {
              return Center(child: buildProductList(state.products));
            } else if (state is Loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is Error) {
              return Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              );
            } else {
              return const Text('EMPTY');
            }
          },
        ),
      ),
    );
  }

  Column buildProductList(List<Product> products) {
    var allTitles = products.map((e) => Text(e.title)).toList();
    return Column(
      children: [...allTitles],
    );
  }
}
