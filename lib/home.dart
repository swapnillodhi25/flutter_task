import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> products = [
    {
      "title": "AKG N700NCM2 Wireless Headphones",
      "price": "\$199.00",
      "image": "assets/images/1.png",
      "availability": "Available",
      "availabilityColor": Colors.green,
    },
    {
      "title": "AIAIAI TMA-2 Modular Headphones",
      "price": "\$250.00",
      "image": "assets/images/2.png",
      "availability": "Unavailable",
      "availabilityColor": Colors.red,
    },
  ];

  List<Map<String, dynamic>> accessories = [
    {
      "title": "AIAIAI 3.5mm Jack 2m",
      "price": "\$25.00",
      "image": "assets/images/3.png",
      "availability": "Available",
      "availabilityColor": Colors.green,
    },
    {
      "title": "AIAIAI 3.5mm Jack 1.5m",
      "price": "\$15.00",
      "image": "assets/images/4.png",
      "availability": "Unavailable",
      "availabilityColor": Colors.red,
    },
  ];

  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> filteredAccessories = [];

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products);
    filteredAccessories = List.from(accessories);
  }

  void addNewItem(String title, String price, bool isProduct) {
    final newItem = {
      "title": title,
      "price": price,
      "image": "assets/images/placeholder.png",
      "availability": "Available",
      "availabilityColor": Colors.green,
    };
    setState(() {
      if (isProduct) {
        products.add(newItem);
        filteredProducts.add(newItem);
      } else {
        accessories.add(newItem);
        filteredAccessories.add(newItem);
      }
    });
  }

  void deleteItem(int index, bool isProduct) {
    setState(() {
      if (isProduct) {
        products.removeAt(index);
        filteredProducts = List.from(products);
      } else {
        accessories.removeAt(index);
        filteredAccessories = List.from(accessories);
      }
    });
  }

  void searchItems(String query) {
    setState(() {
      filteredProducts = products
          .where((item) =>
              item['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredAccessories = accessories
          .where((item) =>
              item['title']!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Hi-Fi Shop & Service",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: ProductSearchDelegate(products, accessories),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Audio shop on Rustaveli Ave 57.\nThis shop offers both products and services.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader("Products", filteredProducts.length, true),
            const SizedBox(height: 10),
            _buildGrid(filteredProducts, true),
            const SizedBox(height: 20),
            _buildSectionHeader(
                "Accessories", filteredAccessories.length, false),
            const SizedBox(height: 10),
            _buildGrid(filteredAccessories, false),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddItemDialog(addNewItem),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, bool isProduct) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title ($count)",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text("Show all", style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> items, bool isProduct) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _buildItem(
          item['title'],
          item['price'],
          item['availability'],
          item['availabilityColor'],
          item['image'],
          () => deleteItem(index, isProduct),
        );
      },
    );
  }

  Widget _buildItem(String title, String price, String availability,
      Color availabilityColor, String imagePath, VoidCallback onDelete) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(imagePath, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(price, style: TextStyle(color: Colors.grey)),
          Row(
            children: [
              CircleAvatar(radius: 4, backgroundColor: availabilityColor),
              const SizedBox(width: 4),
              Text(availability, style: TextStyle(color: availabilityColor)),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
              icon: Icon(Icons.delete, color: Colors.grey),
              onPressed: onDelete,
            ),
          ),
        ],
      ),
    );
  }
}

class AddItemDialog extends StatefulWidget {
  final Function(String, String, bool) onAdd;

  const AddItemDialog(this.onAdd, {Key? key}) : super(key: key);

  @override
  State<AddItemDialog> createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isProduct = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add ${_isProduct ? "Product" : "Accessory"}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: "Name"),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(labelText: "Price"),
          ),
          Row(
            children: [
              Text("Type:"),
              const SizedBox(width: 10),
              DropdownButton<bool>(
                value: _isProduct,
                items: [
                  DropdownMenuItem(value: true, child: Text("Product")),
                  DropdownMenuItem(value: false, child: Text("Accessory")),
                ],
                onChanged: (value) {
                  setState(() {
                    _isProduct = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onAdd(
                _nameController.text, _priceController.text, _isProduct);
            Navigator.pop(context);
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}

class ProductSearchDelegate extends SearchDelegate {
  final List<Map<String, dynamic>> products;
  final List<Map<String, dynamic>> accessories;

  ProductSearchDelegate(this.products, this.accessories);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredProducts = products
        .where((item) =>
            item['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final filteredAccessories = accessories
        .where((item) =>
            item['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResult(filteredProducts, filteredAccessories);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredProducts = products
        .where((item) =>
            item['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    final filteredAccessories = accessories
        .where((item) =>
            item['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return _buildSearchResult(filteredProducts, filteredAccessories);
  }

  Widget _buildSearchResult(List<Map<String, dynamic>> products,
      List<Map<String, dynamic>> accessories) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (products.isNotEmpty) ...[
            Text(
              "Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildGrid(products),
          ],
          if (accessories.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              "Accessories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildGrid(accessories),
          ],
          if (products.isEmpty && accessories.isEmpty)
            Center(
              child: Text(
                "No items found.",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<Map<String, dynamic>> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: Image.asset(item['image'], fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(item['price'], style: TextStyle(color: Colors.grey)),
              Row(
                children: [
                  CircleAvatar(
                      radius: 4, backgroundColor: item['availabilityColor']),
                  const SizedBox(width: 4),
                  Text(
                    item['availability'],
                    style: TextStyle(color: item['availabilityColor']),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
