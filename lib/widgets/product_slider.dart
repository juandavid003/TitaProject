import 'package:odontobb/constant.dart';
import 'package:odontobb/models/product_model.dart';
import 'package:odontobb/screens/item_detail_page/item_detail_screen.dart';
import 'package:odontobb/services/file_service.dart';
import 'package:odontobb/util.dart';
import 'package:odontobb/widgets/custom_elements/normal_text.dart';
import 'package:odontobb/widgets/shimmer_widger.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductSlider extends StatelessWidget {
  final List<ProductModel> products;

  const ProductSlider({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: Utils.size(context).height * 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Dos tarjetas por fila
              crossAxisSpacing: 0, // Espaciado horizontal entre tarjetas
              mainAxisSpacing: 0, // Espaciado vertical entre tarjetas
              childAspectRatio: 0.8, // Ajuste de proporción ancho-alto
            ),
            itemCount: products.length,
            itemBuilder: (_, int index) => _ProductCard(products[index]),
          )),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard(this.product);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
        color: Colors.white, // Fondo claro para un look más limpio
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemDetailScreen(
                id: product.id,
                title: product.title!,
                description: product.description,
                imageUrl: product.imageUrl, 
                linkDemo: product.linkDemo,
                linkProduct: product.linkProduct,
                category: product.category,
                price: product.price,
                forClients: product.forClients,
                imageName: product.image,
                from: 'ToLearn'
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Hero(
                    tag: product.title!,
                    child: _image(product, context),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                    ),
                    child: NormalText(
                      text: product.category!,
                      textSize: kNormalFontSize,
                      fontWeight: FontWeight.w400,
                      textColor: Colors.white,
                      textOverflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: NormalText(
                text: product.title!,
                textSize: kMicroFontSize,
                textColor: Utils.getColorMode(),
                fontWeight: FontWeight.w400,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _image(ProductModel item, BuildContext context) {
    return ClipRRect(
        //borderRadius: BorderRadius.circular(15.0),
        child: item.imageUrl?.isNotEmpty == true
            ? _imagesProducts(item, context)
            : FutureBuilder(
                future: FileService.loadImage('products/${item.image}'),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    item.imageUrl = snapshot.data!;
                    return _imagesProducts(item, context);
                  } else {
                    return ShimmerWidget(
                      child: Container(
                        width: double.infinity,
                        height: Utils.size(context).height * 0.2,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15.0),
                            topRight: Radius.circular(15.0),
                          ),
                          color: kWhiteColor,
                        ),
                      ),
                    );
                  }
                }));
  }

  Widget _imagesProducts(ProductModel item, BuildContext context) {
    return CachedNetworkImage(
        imageUrl: item.imageUrl!,
        fit: BoxFit.fitWidth,
        width: double.infinity,
        height: Utils.size(context).height * 0.2);
  }
}
