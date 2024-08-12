import 'dart:io';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;
  ChatUser medlensUser = ChatUser(id: "1", firstName: "Medlens");
  List<ChatMessage> messages = [];
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false; // Loading state

  void _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendMessage() async {
    String userText = _textController.text.trim();
    if (userText.isEmpty && _image == null)
      return; // Prevent sending empty messages

    // Create user message
    ChatMessage userMessage = ChatMessage(
      user: ChatUser(id: "0", firstName: "User"), // Current user
      createdAt: DateTime.now(),
      text: userText.isNotEmpty ? userText : "Image sent",
      medias: _image != null
          ? [
              ChatMedia(
                url: _image!.path,
                fileName: _image!.path.split('/').last,
                type: MediaType.image,
              )
            ]
          : null,
    );

    setState(() {
      messages.insert(0, userMessage); // Add user message to the top
      _isLoading = true; // Set loading state to true
    });

    // Prepare the request
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://127.0.0.1:5000/analyze'), // Ensure this URL is correct
    );

    if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('image', _image!.path));
    }
    if (userText.isNotEmpty) {
      request.fields['message'] = userText;
    }

    // Send request to the API
    try {
      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);
      final responseJson = json.decode(responseString);

      // Format the API response for display
      String apiResponse = formatApiResponse(responseJson);

      // Create and display the response message
      ChatMessage responseMessage = ChatMessage(
        user: medlensUser,
        createdAt: DateTime.now(),
        text: apiResponse,
      );

      setState(() {
        messages.insert(0, responseMessage); // Add response message to the top
        _textController.clear(); // Clear text input
        _image = null; // Reset image after sending
        _isLoading = false; // Set loading state to false
      });
    } catch (e) {
      print('Error: $e');
      // Handle error response
      ChatMessage errorMessage = ChatMessage(
        user: medlensUser,
        createdAt: DateTime.now(),
        text: 'Error: $e',
      );

      setState(() {
        messages.insert(0, errorMessage); // Add error message to the top
        _isLoading = false; // Set loading state to false
      });
    }
  }

  String formatApiResponse(Map<String, dynamic> responseJson) {
    // Format the API response for display
    StringBuffer formattedResponse = StringBuffer();
    responseJson.forEach((key, value) {
      formattedResponse.write('$key: $value\n');
    });
    return formattedResponse.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MedLens'),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true, // To show the latest message at the bottom
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                title: Align(
                  alignment: message.user.id == medlensUser.id
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: message.user.id == medlensUser.id
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.user.id == medlensUser.id
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_isLoading) // Show loading indicator when waiting for response
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Enter your message',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              IconButton(
                icon: const Icon(Icons.image),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
