import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class expense_details extends StatefulWidget {
  const expense_details({super.key});

  @override
  State<expense_details> createState() => _expense_detailsState();
}

class _expense_detailsState extends State<expense_details> {
  List<Map<String, dynamic>> media = [];
  bool isRecording = false;

  TextEditingController _date = TextEditingController();
  bool isLoading = false;
  FilePickerResult? result;
  String? _filename;
  PlatformFile? pickedfile;
  File? filetodisplay;

  void pick_file() async {
    try {
      setState(() {
        isLoading = true;
      });

      result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          //  allowedExtensions: ['jpg', 'pdf', 'doc','jpeg'],
          allowMultiple: false);

      if (result != null) {
        _filename = result!.files.first.name;
        pickedfile = result!.files.first;
        filetodisplay = File(pickedfile!.path.toString());

        print('File name$_filename');
        // bottomDialog();
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void bottomDialog() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                child: Column(
                  children: [

                    SizedBox(
                      height: 16,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          alignment: Alignment.center,
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(color: Colors.grey[350]),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: media.length,
                              itemBuilder: (context, index) {
                                return attachmentWidget(media[index]);
                              }),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Wrap(
                      children: [
                        iconTextButto('Take a photo', Colors.orange, () {},
                            Icon(Icons.camera_alt), context),
                        iconTextButto('Take a video', Colors.orange, () {},
                            Icon(Icons.video_call), context),
                        iconTextButto('Take a voice', Colors.orange, () {},
                            Icon(Icons.mic), context),
                        iconTextButto('choose a photo', Colors.orange,
                            () async {
                          media.clear();
                          final images = await ImagePicker()
                              .pickImage(source: ImageSource.camera);

                          if (images != null) {
                            //   for (var i = 0; i < images.length; i++) {
                            File file = File(images.path);

                            setState(() {
                              media.add({
                                'type': 'images',
                                'file': file,
                              });
                            });
                            //  }
                          }
                        }, Icon(Icons.photo), context),
                        iconTextButto('Select a video', Colors.orange, () {},
                            Icon(Icons.video_camera_back_outlined), context),
                        iconTextButto('Choose a file', Colors.orange, () {},
                            Icon(Icons.attach_file), context),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              //  Navigator.push(context, MaterialPageRoute(builder: (context)=>new_travel_exp()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: Text("Expenses Details "),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20),
            child: InkWell(
              child: Container(
                alignment: Alignment.topRight,
                child: ElevatedButton.icon(
                    onPressed: () {
                      media.clear();
                      bottomDialog();
                    },
                    icon: ImageIcon(AssetImage("assets/images/add_icon.png")),
                    label: Text("Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    )),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: DropdownButtonFormField<String>(
              // hint: Text("Leave Type",style: TextStyle(color: Colors.black),),
              borderRadius: BorderRadius.circular(8),
              items: <String>[
                'Draft',
                'Submitted',
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              dropdownColor: Colors.white,
              onChanged: (_) {},
              decoration: const InputDecoration(
                  labelText: "Draft",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder()),
            ),
          ),
        ],
      )),
    );
  }
}

Widget iconTextButto(String name, Color colo, Function function, Icon icon,
    BuildContext context) {
  return GestureDetector(
    onTap: () {
      function();
    },
    child: Container(
      width: MediaQuery.of(context).size.width * 0.3,
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(

        children: [

          Container(
            height: 50,
            width: 50,
            child: icon,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colo,
            ),
          ),
          SizedBox(height: 20,),
          Text(name),
        ],
      ),
    ),
  );
}

Widget attachmentWidget(Map<String, dynamic> attachFile) {
  return Container(
    child: Column(
      children: [
        Image.file(
          attachFile['file'],
          fit: BoxFit.cover,
          width: 120,
          height: 120,
        ),

        /*    ClipRRect(
          borderRadius: BorderRadius.circular(0),
          child: Image.file(attachFile['file'],fit: BoxFit.fill,width: 120,height: 120,),
        )*/
      ],
    ),
    /*   width: 120,
    height: 120,
    color: Colors.white,
    margin: const EdgeInsets.only(right: 10),
    child: */
  );
}
// Code via rahul

/*

 return StatefulBuilder(builder: (context, setState) {
            return Scaffold(
              body: Container(
                //  height: 500,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Column(
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                      labelText: "Amount",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      hintText: "000",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Estimate Amount",
                                      labelStyle:
                                          TextStyle(color: Colors.black)),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                      labelText: "Currency Exchange",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      hintText: "INR",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Exchange Rate",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      hintText: "0000"),
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Flexible(
                                child: TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      // labelText: "Amount",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      hintText: "No Data",
                                      border: OutlineInputBorder()),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Flexible(
                                child: TextField(
                                  controller: _date,
                                  decoration: const InputDecoration(
                                      labelText: "Select Date",
                                      labelStyle:
                                          TextStyle(color: Colors.black),
                                      border: OutlineInputBorder(),
                                      suffixIcon:
                                          Icon(Icons.calendar_today_rounded)),
                                  onTap: () async {
                                    DateTime? pickeddate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2000),
                                        lastDate: DateTime(2101));
                                    if (pickeddate != null) {
                                      setState(() {
                                        _date.text = DateFormat('dd-mm-yyyy')
                                            .format(pickeddate);
                                      });
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      isLoading
                                          ? CircularProgressIndicator()
                                          : ElevatedButton.icon(
                                              onPressed: () async {
                                                pick_file();
                                              },
                                              icon: ImageIcon(AssetImage(
                                                  "assets/images/add_icon.png")),
                                              label: Text("Upload Bills"),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange,
                                              ),
                                            ),
                                      SizedBox(width: 20),
                                      if (pickedfile != null)
                                        SizedBox(
                                          height: 80,
                                          width: 80,
                                          child: Image.file(
                                            filetodisplay!,
                                            width: 35,
                                            height: 35,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: InkWell(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromARGB(255, 3, 114, 240)),
                              child: const Center(
                                child: Text(
                                  "Submit",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            onTap: () {
                              //                                            Navigator.push(
                              // context,
                              // MaterialPageRoute(builder: (context) =>  expense_details()),);
                            },
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
            );
          });
* */
