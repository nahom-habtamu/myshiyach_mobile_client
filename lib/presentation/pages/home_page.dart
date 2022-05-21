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
        backgroundColor: const Color(0xffF1F1F1),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Text('Products'),
              buildCategories([
                "All",
                "Electronics",
                "Food",
                "Trending",
                "Electronics",
                "Food",
                "Trending"
              ]),
              Expanded(
                child: BlocBuilder<GetAllProductsCubit, GetAllProductsState>(
                  builder: (context, state) {
                    if (state is Loaded) {
                      return Center(
                        child: buildProductList(state.products),
                      );
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
              )
            ],
          ),
        ),
      ),
    );
  }

  buildCategories(List<String> categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: SizedBox(
        height: 35,
        child: ListView.builder(
          itemCount: categories.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 35,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 3,
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF686666)),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  buildProductList(List<Product> products) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.83,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return buildProduct(products[index]);
      },
    );
  }

  Container buildProduct(Product product) {
    return Container(
      margin: const EdgeInsets.all(5),
      width: MediaQuery.of(context).size.width * 0.45,
      height: 210,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          renderProductListItemImage(),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  renderTitle(),
                  renderDescription(),
                  renderPrice(),
                  renderTimerAndFavoriteIcon()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  SizedBox renderTitle() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 32,
      child: const Text(
        'BARGAIN Thinkpad X1 extreme 15”6 4K I7 GTX',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
          fontSize: 12,
          letterSpacing: 0.1,
        ),
      ),
    );
  }

  SizedBox renderDescription() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.45,
      height: 10,
      child: const Text(
        'I7-8750H (4.3 GHZ) * GTX 1050ti (4GB VRAM)',
        style: TextStyle(
          color: Color(0xff888888),
          fontSize: 8,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Padding renderPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        color: const Color(0xffF5FFF8),
        width: MediaQuery.of(context).size.width * 0.45,
        child: const Text(
          '6500 birr',
          style: TextStyle(
            color: Color(0xff34A853),
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }

  Row renderTimerAndFavoriteIcon() {
    return Row(
      children: const [
        Icon(
          Icons.access_time_rounded,
          size: 18,
          color: Colors.grey,
        ),
        SizedBox(
          width: 4,
        ),
        Expanded(
          child: Text(
            'Just Now',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
        ),
        CircleAvatar(
          radius: 13,
          backgroundColor: Color.fromRGBO(233, 225, 225, 1),
          child: Icon(
            Icons.favorite_border,
            size: 20,
            color: Colors.red,
          ),
        ),
      ],
    );
  }

  SizedBox renderProductListItemImage() {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width * 0.45,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        child: Image.network(
          'https://images.unsplash.com/photo-1652487346675-908df8c01529?crop=entropy&cs=tinysrgb&fm=jpg&ixlib=rb-1.2.1&q=60&raw_url=true&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHw1fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
