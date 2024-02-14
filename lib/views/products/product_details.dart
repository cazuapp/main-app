/*
 * CazuApp - Delivery at convenience.  
 * 
 * Copyright 2023 - Carlos Ferry <cferry@cazuapp.dev>
 *
 * This file is part of CazuApp. CazuApp is licensed under the New BSD License: you can
 * redistribute it and/or modify it under the terms of the BSD License, version 3.
 * This program is distributed in the hope that it will be useful, but without
 * any warranty.
 *
 * You should have received a copy of the New BSD License
 * along with this program. <https://opensource.org/licenses/BSD-3-Clause>
 */

import 'package:cazuapp/components/failure.dart';
import 'package:cazuapp/components/navigator.dart';
import 'package:cazuapp/models/variant_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../../bloc/favorites/favorite_list/bloc.dart';
import '../../../bloc/products/product_info/bloc.dart';
import '../../../bloc/user/auth/bloc.dart';
import '../../../components/progress.dart';
import '../../../core/theme.dart';
import '../../../components/utext.dart';
import '../../bloc/cart/cart_list/bloc.dart';
import '../../models/variant.dart';
import '../cart/checkout.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductDetailPage extends StatelessWidget {
  final int id;

  const ProductDetailPage({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (_) => ProductInfoBloc(
                id: id,
                instance: BlocProvider.of<AuthenticationBloc>(context).instance)
              ..add(const ProductInfoRequest())),
        BlocProvider(
            create: (_) => FavoriteBloc(
                instance:
                    BlocProvider.of<AuthenticationBloc>(context).instance)),
      ],
      child: const ProductInfoForm(),
    );
  }
}

class ProductInfoForm extends StatefulWidget {
  const ProductInfoForm({super.key});

  @override
  State<ProductInfoForm> createState() => _ProductInfoForm();
}

class _ProductInfoForm extends State<ProductInfoForm> {
  @override
  void initState() {
    context.read<CartListBloc>().add(ResetCounter());
    super.initState();
  }

  Widget _gettotal() {
    return BlocBuilder<CartListBloc, CartListState>(builder: (context, state) {
      double price =
          context.select((ProductInfoBloc bloc) => bloc.state.inUse.price) *
              state.counter;

      return Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              utext(
                  title: "Total",
                  color: AppTheme.main,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
              const SizedBox(height: 1),
              utext(
                title: "\$${price.toStringAsFixed(2)}",
                color: AppTheme.main,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ],
          ));
    });
  }

  Widget submitButton() {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
      builder: (context, state) {
        int total = context.select((CartListBloc bloc) => bloc.state.counter);

        return SizedBox(
            height: 45,
            width: ScreenUtil().scaleWidth * 150,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(0),
                  elevation: 5.0,
                  backgroundColor:
                      total > 0 ? AppTheme.subprimarycolor : AppTheme.yesArrow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                key: const Key('signupForm_continue_raisedButton'),
                onPressed: () {
                  if (total > 0) {
                    BlocProvider.of<CartListBloc>(context).add(CartListAdd(
                        product: state.dual.model, variant: state.inUse));
                    BlocProvider.of<CartListBloc>(context)
                      ..add(CartListReset())
                      ..add(CartListFetch())
                      ..add(CartListPre())
                      ..add(CartGetHolds());
                    Navigator.pop(context);
                    navigate(context, const CheckoutPage());
                  }
                },
                child: utext(
                    textAlign: TextAlign.center,
                    title: "Add to cart",
                    align: Alignment.center,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.white)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
        builder: (context, state) {
      switch (state.current) {
        case ProducInfoStatus.loading:
          return const Loader();

        case ProducInfoStatus.initial:
          return const Loader();

        case ProducInfoStatus.failure:
          return const FailurePage(
              title: "Error", subtitle: "Failed to retrieve product");

        case ProducInfoStatus.success:
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: AppTheme.mainbg,
              bottomNavigationBar: Container(
                  height: 100,
                  padding: const EdgeInsets.all(3.0),
                  decoration: const BoxDecoration(
                      color: AppTheme.white,
                      border: Border(
                          top: BorderSide(
                        color: AppTheme.white,
                        width: 1.0,
                      ))),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        submitButton(),
                        _gettotal(),
                      ],
                    ),
                  )),
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent,
                  statusBarIconBrightness: Brightness.dark,
                ),
                child: SafeArea(
                  child: Container(
                    decoration: const BoxDecoration(
                        gradient: LinearGradient(
                      colors: [
                        Color(0xfffbfbfb),
                        Color(0xfff7f7f7),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                    child: const Stack(
                      children: <Widget>[
                        SingleChildScrollView(
                            child: Column(
                          children: <Widget>[
                            ProductImage(),
                          ],
                        )),
                        DetailWidget(),
                      ],
                    ),
                  ),
                ),
              ));
      }
    });
  }
}

class Variants extends StatefulWidget {
  const Variants({super.key});

  @override
  State<Variants> createState() => _Variants();
}

class _Variants extends State<Variants> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
        builder: (context, state) {
      List<Variant> items = state.dual.model2;
      Variant inUse = state.inUse;

      if (items.isEmpty || items.length == 1) {
        return const SizedBox.shrink();
      }

      List<dynamic> ids = [];

      for (var i = 0; i < items.length; i++) {
        var format = {
          "id": items[i].id.toString(),
          "title": items[i].title,
          "index": i.toString()
        };

        ids.add(format);
      }

      String? selectedValue;
      String original = inUse.title;

      return Padding(
          padding: const EdgeInsets.only(top: 5),
          child: DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              isExpanded: true,
              hint: Row(
                children: [
                  const Icon(
                    Icons.list,
                    size: 16,
                    color: AppTheme.black,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Text(
                      original,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              items: ids
                  .map((dynamic item) => DropdownMenuItem<String>(
                        value: item["index"],
                        child: Text(
                          item["title"],
                          style: GoogleFonts.ubuntu(
                            fontSize: 15.0,
                            color: AppTheme.black,
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                  .toList(),
              value: selectedValue,
              onChanged: (String? value) {
                int index = int.parse(value!);

                BlocProvider.of<ProductInfoBloc>(context)
                    .add(ChangeInUse(variant: items[index]));
                BlocProvider.of<ProductInfoBloc>(context).add(ChangeDisplay(
                    image: items[index].images.first.image, index: 0));
              },
              buttonStyleData: ButtonStyleData(
                height: 50,
                width: 160,
                padding: const EdgeInsets.only(left: 14, right: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: Colors.black26,
                  ),
                  color: AppTheme.white,
                ),
                elevation: 2,
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_forward_ios_outlined,
                ),
                iconSize: 14,
                iconEnabledColor: AppTheme.black,
                iconDisabledColor: Colors.grey,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: AppTheme.white,
                ),
                offset: const Offset(0, 0),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: MaterialStateProperty.all<double>(6),
                  thumbVisibility: MaterialStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ));
    });
  }
}

class ListTileItem extends StatefulWidget {
  const ListTileItem({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ListTileItemState createState() => _ListTileItemState();
}

class _ListTileItemState extends State<ListTileItem> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartListBloc, CartListState>(builder: (context, state) {
      return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
            color: const Color.fromARGB(255, 242, 241, 241),
            border: Border.all(
              color: AppTheme.white,
            ),
          ),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                    child: Container(
                  width: 52,
                  height: 52,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                    color: AppTheme.subprimarycolor,
                  ),
                  child: IconButton(
                      splashRadius: 16,
                      constraints: const BoxConstraints(),
                      iconSize: 12,
                      padding: EdgeInsets.zero,
                      color: AppTheme.white,
                      icon: const Icon(FontAwesomeIcons.minus),
                      onPressed: () => {
                            context.read<CartListBloc>().add(CartOp(op: false)),
                            context.read<CartListBloc>().add(SetPrice(
                                price: context.select((ProductInfoBloc bloc) =>
                                    bloc.state.inUse.price)))
                          }),
                )),
                SizedBox(
                    width: 42,
                    child: utext(
                        align: Alignment.center,
                        title: state.counter.toString(),
                        fontWeight: state.counter > 0
                            ? FontWeight.w800
                            : FontWeight.w500)),
                InkWell(
                    child: Container(
                        width: 52,
                        height: 52,
                        margin: const EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          shape: BoxShape.rectangle,
                          color: AppTheme.subprimarycolor,
                        ),
                        child: IconButton(
                            splashRadius: 16,
                            color: AppTheme.white,
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            iconSize: 12,
                            icon: const Icon(FontAwesomeIcons.plus),
                            onPressed: () => {
                                  context
                                      .read<CartListBloc>()
                                      .add(CartOp(op: true)),
                                })))
              ]));
    });
  }
}

class DetailWidget extends StatelessWidget {
  const DetailWidget({super.key});

  Widget _description() {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
        builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          utext(
              title: "Description",
              color: AppTheme.main,
              fontWeight: FontWeight.w500),
          const SizedBox(height: 5),
          utext(title: state.dual.model.description, color: AppTheme.darkgray),
        ],
      );
    });
  }

  Widget _thumbnail(int index, String image, bool current) {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
        builder: (context, state) {
      return InkWell(
        onTap: () => {
          context.read<ProductInfoBloc>()
            ..add(ChangeDisplay(index: index, image: image)),
        },
        child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            width: 60,
            decoration: current
                ? const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.green,
                      Color.fromARGB(255, 144, 255, 59),
                      Color.fromARGB(255, 54, 187, 244),
                      Colors.purple
                    ]),
                    shape: BoxShape.circle)
                : null,
            child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  padding: const EdgeInsets.all(2.0),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    foregroundImage: NetworkImage(image),
                  ),
                ))),
      );
    });
  }

  Widget thumbList() {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
        builder: (context, state) {
      List<VariantImage> imagelist = state.inUse.images;

      if (imagelist.isEmpty || imagelist.length == 1) {
        return const SizedBox.shrink();
      }

      return Center(
          child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                ...List.generate(
                  imagelist.length,
                  (index) => _thumbnail(index, imagelist[index].image,
                      state.index == index ? true : false),
                ),
              ])));
    });
  }

  @override
  Widget build(BuildContext context) {
    double maxChildSize = 0.9; // 90% of screen height
    MediaQuery.of(context).size.height; // Calculate based on design height
    double calculatedInitialSize = 390.h / MediaQuery.of(context).size.height;
    double initialChildSize = calculatedInitialSize <= maxChildSize
        ? calculatedInitialSize
        : maxChildSize;

    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
      builder: (context, state) {
        return DraggableScrollableSheet(
          maxChildSize: maxChildSize,
          initialChildSize: initialChildSize,
          minChildSize: .54,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(2),
                  topRight: Radius.circular(2),
                ),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Container(
                            width: 30,
                            height: 2,
                            decoration: const BoxDecoration(
                              color: AppTheme.title,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                          ),
                        ),
                      ),
                      thumbList(),
                      const Variants(),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                utext(
                                  title: state.inUse.title,
                                  fontWeight: FontWeight.w700,
                                  color: AppTheme.black,
                                  fontSize: 16,
                                  textAlign: TextAlign.start,
                                ),
                                utext(
                                  fontWeight: FontWeight.w400,
                                  title: "\$${state.inUse.price.toString()}",
                                  fontSize: 17,
                                ),
                              ],
                            ),
                            const ListTileItem(), // Assuming this is the counter widget
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Divider(
                        color: AppTheme.darkset,
                        height: 5,
                        thickness: 1,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            state.dual.model.description != ''
                                ? _description()
                                : const SizedBox.shrink(),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({super.key});

  Widget getImg() {
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
        builder: (context, state) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Colors.white,
                ),
              ),
              height: 31,
              width: 43,
              child: InkWell(
                child: Icon(
                  state.liked == true
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color:
                      state.liked == true ? AppTheme.alert : AppTheme.darkgray,
                  size: 21,
                ),
                onTap: () => {
                  context
                      .read<ProductInfoBloc>()
                      .add(ProductSetFavorite(status: !state.liked)),
                },
              )),
          const SizedBox(width: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white,
              ),
            ),
            height: 31,
            width: 35,
            child: InkWell(
              child: const Icon(
                  color: AppTheme.black,
                  size: 20,
                  FontAwesomeIcons.ellipsisVertical),
              onTap: () => {
                context
                    .read<ProductInfoBloc>()
                    .add(ProductSetFavorite(status: !state.liked)),
              },
            ),
          )
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<ProductInfoBloc, ProductInfoState>(
        builder: (context, state) {
      List<VariantImage> imagelist = state.inUse.images;

      return Stack(children: <Widget>[
        InkWell(
            onDoubleTap: () {
              context
                  .read<ProductInfoBloc>()
                  .add(ProductSetFavorite(status: !state.liked));
            },
            child: Container(
                decoration: const BoxDecoration(color: Colors.white),
                alignment: Alignment.center,
                child: Image.network(
                  state.display,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset('assets/null.png');
                  },
                ))),
        Padding(
            padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.03, vertical: size.height * 0.02),
            child: Align(
              alignment: Alignment.topLeft,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      height: 35,
                      width: 35,
                      child: const Icon(FontAwesomeIcons.arrowLeftLong,
                          size: 18, color: AppTheme.black))),
            )),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.02, vertical: size.height * 0.02),
          child: Align(
            alignment: Alignment.topRight,
            child: getImg(),
          ),
        ),
        (state.index) != 0
            ? Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.02,
                    vertical: size.height * 0.19),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () => {
                              (state.index) != 0
                                  ? BlocProvider.of<ProductInfoBloc>(context)
                                      .add(ChangeDisplay(
                                          index: state.index - 1,
                                          image:
                                              imagelist[state.index - 1].image))
                                  : null
                            },
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.settings,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            height: 25,
                            width: 25,
                            child: const Icon(FontAwesomeIcons.arrowLeft,
                                size: 12, color: AppTheme.black)))))
            : const SizedBox.shrink(),
        (state.index + 1) < imagelist.length
            ? Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                    onTap: () => {
                          (state.index + 1) < imagelist.length
                              ? BlocProvider.of<ProductInfoBloc>(context).add(
                                  ChangeDisplay(
                                      index: state.index + 1,
                                      image: imagelist[state.index + 1].image))
                              : null
                        },
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.02,
                            vertical: size.height * 0.19),
                        child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.settings,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                            height: 25,
                            width: 25,
                            child: const Icon(FontAwesomeIcons.arrowRight,
                                size: 12, color: AppTheme.black)))))
            : const SizedBox.shrink(),
      ]);
    });
  }
}
