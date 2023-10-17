import 'package:flutter/material.dart';
import 'package:fresh_farm/models/item_model.dart';
import 'package:fresh_farm/widget/update_item_details.dart';


class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.itemData,
    required this.uid,
  });
  final ItemModel itemData;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (ctx) => UpdateItem(itemData: itemData, uid: uid),
          );
        },
        child: Stack(children: [
          Hero(
            tag: itemData.itemName,
            child: Container(child: itemData.image),
            // child: FadeInImage.memoryNetwork(
            //   placeholder: kTransparentImage,
            //   image: itemData.,
            // ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 44,
                ),
                child: Column(children: [
                  Text(
                    itemData.itemName,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 30),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Price/kg :  ₹  ${itemData.cost}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Spacer(),
                      Text(
                        'Instock : ${itemData.quantity} Kg',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  )
                ]),
              )),
        ]),
      ),
    );
  }
}
