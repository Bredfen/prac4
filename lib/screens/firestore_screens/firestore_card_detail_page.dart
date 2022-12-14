import 'package:flutter/material.dart';
import 'package:mirea_db/api/translate_api.dart';
import 'package:mirea_db/model/firestore_pos_model.dart';
import 'package:mirea_db/services/firestore_crud_helper.dart';

class FireStoreCardDetail extends StatefulWidget {
  final FirestorePosModel? firestorePos;
  final String? docId;
  final String? collectionName;
  const FireStoreCardDetail(
      {Key? key, this.firestorePos, this.docId, this.collectionName})
      : super(key: key);
  const FireStoreCardDetail.createNewDetail(this.collectionName,
      [Key? key, this.firestorePos, this.docId])
      : super(key: key);

  @override
  State<FireStoreCardDetail> createState() => _FireStoreCardDetailState();
}

class _FireStoreCardDetailState extends State<FireStoreCardDetail> {
  String titleBuffer = '';
  String subtitleBuffer = '';
  String priceBuffer = '';
  bool titleLanguageFlag = false;
  bool subtitleLanguageFlag = false;
  final titleController = TextEditingController();
  final subtitleController = TextEditingController();
  final priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.firestorePos != null) {
      //фикс цыганского бага
      titleController.text = (titleController.text.isNotEmpty &&
              widget.firestorePos!.title != titleController.text
          ? titleController.text
          : widget.firestorePos!.title)!;
      subtitleController.text = (subtitleController.text.isNotEmpty &&
              widget.firestorePos!.subtitle != subtitleController.text
          ? subtitleController.text
          : widget.firestorePos!.subtitle)!;
      priceController.text = (priceController.text.isNotEmpty &&
              widget.firestorePos!.price != priceController.text
          ? priceController.text
          : widget.firestorePos!.price)!;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.firestorePos == null ? 'Добавить' : 'Редактировать',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontFamily: "PricedownBl")),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: titleController,
                maxLines: 1,
                decoration: InputDecoration(
                  //hintText: 'Введите название',
                  labelText: 'Название',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "PricedownBl"),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => titleTranslator(),
                    icon: const Icon(Icons.language),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: subtitleController,
                decoration: InputDecoration(
                  //hintText: 'Введите описание',
                  labelText: 'Описание',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "PricedownBl"),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () => subtitleTranslator(),
                    icon: const Icon(Icons.language),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Цена',
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: "PricedownBl"),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10.0),
                    ),
                  ),
                ),
                keyboardType: TextInputType.multiline,
                maxLines: 1,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () async {
                      final title = titleController.text;
                      final subtitle = subtitleController.text;
                      final price = priceController.text;
                      if (title.isEmpty || subtitle.isEmpty || price.isEmpty) {
                        return;
                      }

                      final FirestorePosModel model = FirestorePosModel(
                        title: title,
                        subtitle: subtitle,
                        price: price,
                      );
                      try {
                        if (widget.firestorePos == null) {
                          await FireStoreHelper.addFireStorePos(
                              model, 'DrugPos');
                        } else {
                          await FireStoreHelper.updateFireStorePos(
                              model, widget.docId.toString(), 'DrugPos');
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }

                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    },
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                side: BorderSide(
                                  color: Colors.white,
                                  width: 0.75,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0),
                                )))),
                    child: Text(
                      widget.firestorePos == null
                          ? 'Сохранить'
                          : 'Редактировать',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "PricedownBl",
                          fontSize: 20),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  titleTranslator() async {
    if (titleController.text.isNotEmpty) {
      titleLanguageFlag = !titleLanguageFlag;
      if (titleLanguageFlag) {
        titleBuffer = titleController.text;
        titleController.text = await fetchTranslate(titleController.text);
      } else {
        titleController.text = titleBuffer;
      }
    }
  }

  subtitleTranslator() async {
    if (subtitleController.text.isNotEmpty) {
      subtitleLanguageFlag = !subtitleLanguageFlag;
      if (subtitleLanguageFlag) {
        subtitleBuffer = subtitleController.text;
        subtitleController.text = await fetchTranslate(subtitleController.text);
      } else {
        subtitleController.text = subtitleBuffer;
      }
    }
  }
}
