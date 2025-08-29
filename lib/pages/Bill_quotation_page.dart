// import 'package:flutter/material.dart';
// import 'package:relie_nquiry/constants/app_colors.dart';
//
// class QuotationPage extends StatefulWidget {
//   const QuotationPage({super.key});
//
//   @override
//   State<QuotationPage> createState() => _QuotationPageState();
// }
//
// class _QuotationPageState extends State<QuotationPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               height: 150,
//               //  width: 100,
//               "asset/image/coming soon.jpg",
//             ),
//             Text(
//               "Quotation",
//               style: TextStyle(
//                 color: AppColors.appColor,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 22,
//               ),
//             ),
//             Text(
//               "Coming Soon...",
//               style: TextStyle(
//                 color: Colors.grey,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 28,
//               ),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.of(context).pop();
//         },
//         elevation: 5,
//         shape: const CircleBorder(),
//         backgroundColor: AppColors.appColor,
//         child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
//       ),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:relie_nquiry/22.dart';
import 'package:relie_nquiry/bill/Quotation.dart';
import 'package:relie_nquiry/constants/app_colors.dart';
import 'package:relie_nquiry/constants/app_constants.dart';
import 'package:relie_nquiry/constants/app_text_styles.dart';
import 'package:relie_nquiry/constants/text_fields.dart';
import 'package:relie_nquiry/constants/uppercase_formatter.dart';

class ProductFromExcel {
  String name;
  double price;
  int quantity;
  bool isSelected;
  double discount;

  ProductFromExcel({
    required this.name,
    required this.price,
    this.quantity = 1,
    this.isSelected = false,
    this.discount = 0.0,
  });

  double get discountedPrice => price - (price * discount / 100);

  double get total => discountedPrice * quantity;

  double get discountAmount => (price * discount / 100) * quantity;

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "qty": quantity,
      "rate": price.toInt(),
      "discount": discount,
      "discountedRate": discountedPrice.toInt(),
      "total": total.toInt(),
    };
  }
}

class BillQuotationPage extends StatefulWidget {
  final String?
  existingDocumentId; // Accept existing document ID from constructor
  final Map<String, dynamic>? existingData; // Accept existing data for editing

  const BillQuotationPage({
    super.key,
    this.existingDocumentId,
    this.existingData,
  });

  @override
  State<BillQuotationPage> createState() => _BillQuotationPageState();
}

class _BillQuotationPageState extends State<BillQuotationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _documentType = 'Bill';
  List<ProductFromExcel> _allProducts = [];
  List<ProductFromExcel> _selectedProducts = [];
  bool _isSaved = false;

  String? _documentId; // store the firestore document id after save

  // Discount and controllers
  String _customerType = 'Regular';
  bool _isPercentageDiscount = true;
  double _overallDiscountPercentage = 0.0;
  double _overallDiscountAmount = 0.0;

  final TextEditingController discountController = TextEditingController(
    text: '0',
  );

  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController customerMobileController =
      TextEditingController();
  final TextEditingController customerEmailController = TextEditingController();
  final TextEditingController manualProductNameController =
      TextEditingController();
  final TextEditingController manualProductPriceController =
      TextEditingController();
  final TextEditingController manualProductQuantityController =
      TextEditingController(text: '1');

  bool _showProductSelection = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProductsFromExcel();
    _loadExistingData(); // Load existing data if editing
  }

  void _loadExistingData() {
    if (widget.existingDocumentId != null && widget.existingData != null) {
      setState(() {
        _documentId = widget.existingDocumentId;
        _isSaved = true; // Mark as saved since we're editing existing data

        // Load customer details
        customerNameController.text =
            widget.existingData!['customerName'] ?? '';
        customerMobileController.text =
            widget.existingData!['customerMobile'] ?? '';
        customerEmailController.text =
            widget.existingData!['customerEmail'] ?? '';

        // Load document type
        _documentType = widget.existingData!['documentType'] ?? 'Bill';

        // Load selected products
        List<dynamic> items = widget.existingData!['items'] ?? [];
        _selectedProducts = items.map((item) {
          return ProductFromExcel(
            name: item['name'],
            price: (item['rate'] ?? 0).toDouble(),
            quantity: item['qty'] ?? 1,
            discount: (item['discount'] ?? 0).toDouble(),
            isSelected: true,
          );
        }).toList();

        // Mark products as selected in the all products list
        for (var selectedProduct in _selectedProducts) {
          for (var product in _allProducts) {
            if (product.name == selectedProduct.name) {
              product.isSelected = true;
            }
          }
        }

        // Load discount information
        double overallDiscount = (widget.existingData!['overallDiscount'] ?? 0)
            .toDouble();
        if (overallDiscount > 0) {
          // You might need to determine if it was percentage or fixed amount
          // For now, assuming it was percentage if it's less than or equal to 100
          if (overallDiscount <= afterProductDiscountAmount * 0.5) {
            _isPercentageDiscount = false;
            _overallDiscountAmount = overallDiscount;
            discountController.text = overallDiscount.toString();
          } else {
            _isPercentageDiscount = true;
            _overallDiscountPercentage =
                (overallDiscount / afterProductDiscountAmount) * 100;
            discountController.text = _overallDiscountPercentage.toString();
          }
        }
      });
    }
  }

  void _loadProductsFromExcel() {
    setState(() {
      _allProducts = [
        ProductFromExcel(name: 'LAPTOP HP PAVILION', price: 45000.0),
        ProductFromExcel(name: 'MOUSE LOGITECH', price: 1500.0),
        ProductFromExcel(name: 'KEYBOARD MECHANICAL', price: 2500.0),
        ProductFromExcel(name: 'MONITOR 24 INCH', price: 12000.0),
        ProductFromExcel(name: 'WEBCAM HD', price: 3000.0),
        ProductFromExcel(name: 'HEADPHONE WIRELESS', price: 2000.0),
        ProductFromExcel(name: 'MOBILE PHONE', price: 25000.0),
        ProductFromExcel(name: 'TABLET 10 INCH', price: 15000.0),
        ProductFromExcel(name: 'SPEAKER BLUETOOTH', price: 1800.0),
        ProductFromExcel(name: 'HARD DISK 1TB', price: 4000.0),
      ];
    });
  }

  List<ProductFromExcel> get _filteredProducts {
    if (_searchQuery.isEmpty) return _allProducts;
    return _allProducts
        .where((p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  double get subtotalAmount =>
      _selectedProducts.fold(0.0, (sum, p) => sum + (p.price * p.quantity));

  double get productDiscountAmount =>
      _selectedProducts.fold(0.0, (sum, p) => sum + p.discountAmount);

  double get afterProductDiscountAmount =>
      subtotalAmount - productDiscountAmount;

  double get overallDiscountAmount {
    if (_isPercentageDiscount)
      return afterProductDiscountAmount * (_overallDiscountPercentage / 100);
    return _overallDiscountAmount > afterProductDiscountAmount
        ? afterProductDiscountAmount
        : _overallDiscountAmount;
  }

  double get totalAmount => afterProductDiscountAmount - overallDiscountAmount;

  double get totalSavings => productDiscountAmount + overallDiscountAmount;

  void _addProductToSelected(ProductFromExcel product) {
    setState(() {
      product.isSelected = true;
      _selectedProducts.add(
        ProductFromExcel(
          name: product.name,
          price: product.price,
          quantity: 1,
          isSelected: true,
          discount: 0.0,
        ),
      );
      _isSaved = false;
    });
    // Get.snackbar("Success", "${product.name} added",
    //     backgroundColor: Colors.green, colorText: Colors.white);
  }

  void _removeProductFromSelected(int index) {
    setState(() {
      String productName = _selectedProducts[index].name;
      _selectedProducts.removeAt(index);
      for (var product in _allProducts) {
        if (product.name == productName) product.isSelected = false;
      }
      _isSaved = false;
    });
  }

  void _updateProductQuantity(int index, int newQty) {
    if (newQty > 0) {
      setState(() {
        _selectedProducts[index].quantity = newQty;
        _isSaved = false;
      });
    }
  }

  void _updateProductDiscount(int index, double discount) {
    setState(() {
      _selectedProducts[index].discount = discount;
      _isSaved = false;
    });
  }

  void _updateOverallDiscount(String value) {
    double discountValue = double.tryParse(value) ?? 0.0;

    setState(() {
      if (_isPercentageDiscount) {
        _overallDiscountPercentage = discountValue.clamp(0.0, 100.0);
      } else {
        _overallDiscountAmount = discountValue.clamp(0.0, double.infinity);
      }
      _isSaved = false;
    });
  }

  void _addManualProduct() {
    if (manualProductNameController.text.isNotEmpty &&
        manualProductPriceController.text.isNotEmpty) {
      double price = double.tryParse(manualProductPriceController.text) ?? 0.0;
      int qty = int.tryParse(manualProductQuantityController.text) ?? 1;
      setState(() {
        _selectedProducts.add(
          ProductFromExcel(
            name: manualProductNameController.text.trim(),
            price: price,
            quantity: qty,
            isSelected: true,
            discount: 0.0,
          ),
        );
        _isSaved = false;
      });
      manualProductNameController.clear();
      manualProductPriceController.clear();
      manualProductQuantityController.text = '1';
      Get.snackbar(
        "Success",
        "Manual product added",
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Error",
        "Enter product name & price",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ---------------- Firebase Save (without PDF) ----------------
  Future<String> _saveToFirestore({String? existingDocId}) async {
    if (_selectedProducts.isEmpty) throw Exception('No products to save');

    List<Map<String, dynamic>> items = _selectedProducts
        .map((p) => p.toMap())
        .toList();

    String? employeeUid = FirebaseAuth.instance.currentUser?.uid;

    Map<String, dynamic> doc = {
      'customerName': customerNameController.text.trim(),
      'customerMobile': customerMobileController.text.trim(),
      'customerEmail': customerEmailController.text.trim(),
      'documentType': _documentType,
      'items': items,
      'subtotal': subtotalAmount.toInt(),
      'productDiscount': productDiscountAmount.toInt(),
      'overallDiscount': overallDiscountAmount.toInt(),
      'totalAmount': totalAmount.toInt(),
      'employeeUid': employeeUid,
      'updatedAt': FieldValue.serverTimestamp(),
      'status': _documentType == 'Bill' ? 'completed' : 'saved',
    };

    CollectionReference ref = FirebaseFirestore.instance
        .collection('subscription')
        .doc(AppConstants.companyName)
        .collection("bill&Quotation");

    if (existingDocId != null) {
      // 🟢 Edit → update existing doc
      await ref.doc(existingDocId).update(doc);
      return existingDocId;
    } else {
      // 🟢 New → create new doc
      doc['createdAt'] = FieldValue.serverTimestamp();
      DocumentReference newRef = await ref.add(doc);
      return newRef.id;
    }
  }

  void _saveData() async {
    if (_selectedProducts.isEmpty) {
      Get.snackbar(
        "Error",
        "Please select at least one product",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    try {
      String docId;

      if (_documentId != null) {
        // 🟢 Edit mode → pass docId
        docId = await _saveToFirestore(existingDocId: _documentId);
      } else {
        // 🟢 New save → no docId
        docId = await _saveToFirestore();
      }

      setState(() {
        _isSaved = true;
        _documentId = docId; // 🔑 Save pannina docId store
      });

      // Get.snackbar("Success", "Data saved successfully (ID: $docId).",
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //     duration: Duration(seconds: 4));
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to save: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _generateDocument(String docType) {
    List<Map<String, dynamic>> itemsForQuotation = _selectedProducts
        .map((p) => p.toMap())
        .toList();

    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => QuotationPage(
              customerName: customerNameController.text.trim(),
              customerMobile: customerMobileController.text.trim(),
              customerEmail: customerEmailController.text.trim(),
              items: itemsForQuotation,
              documentType: docType,
              existingDocumentId:
                  _documentId, // 🔑 MAIN FIX: Pass the document ID
            ),
          ),
        )
        .then((result) {
          // Handle any updates from QuotationPage
          if (result != null && result is Map<String, dynamic>) {
            setState(() {
              // If QuotationPage returns updated document ID, use it
              if (result['documentId'] != null) {
                _documentId = result['documentId'];
                _isSaved = true;
              }
              // If QuotationPage indicates data was updated, mark as saved
              if (result['updated'] == true) {
                _isSaved = true;
              }
            });
          }
        });
  }

  void _clearForm() {
    setState(() {
      _documentType = 'Bill';
      _selectedProducts.clear();
      _showProductSelection = false;
      _searchQuery = '';
      _isSaved = false;
      _customerType = 'Regular';
      _isPercentageDiscount = true;
      _overallDiscountPercentage = 0.0;
      _overallDiscountAmount = 0.0;
      discountController.text = '0';
      customerNameController.clear();
      customerMobileController.clear();
      customerEmailController.clear();
      manualProductNameController.clear();
      manualProductPriceController.clear();
      manualProductQuantityController.text = '1';
      _documentId = null; // Clear the document ID
      for (var product in _allProducts) {
        product.isSelected = false;
      }
    });
  }

  // Method to handle any product or data changes after save
  void _onDataChanged() {
    setState(() {
      _isSaved = false; // Mark as unsaved when data changes
    });
  }

  // Override all update methods to call _onDataChanged
  void _updateProductQuantityWithChange(int index, int newQty) {
    if (newQty > 0) {
      setState(() {
        _selectedProducts[index].quantity = newQty;
      });
      _onDataChanged();
    }
  }

  void _updateProductDiscountWithChange(int index, double discount) {
    setState(() {
      _selectedProducts[index].discount = discount;
    });
    _onDataChanged();
  }

  void _updateOverallDiscountWithChange(String value) {
    double discountValue = double.tryParse(value) ?? 0.0;

    setState(() {
      if (_isPercentageDiscount) {
        _overallDiscountPercentage = discountValue.clamp(0.0, 100.0);
      } else {
        _overallDiscountAmount = discountValue.clamp(0.0, double.infinity);
      }
    });
    _onDataChanged();
  }

  // Method to show save status
  Widget _buildSaveStatusIndicator() {
    if (_documentId == null) {
      return Container(); // New document, no status to show
    }

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _isSaved ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isSaved ? Colors.green.shade300 : Colors.orange.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isSaved ? Icons.check_circle : Icons.warning,
            color: _isSaved ? Colors.green : Colors.orange,
            size: 20,
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              _isSaved
                  ? "Document saved (ID: $_documentId)"
                  : "Unsaved changes - Click 'Update Data' to save changes",
              style: TextStyle(
                color: _isSaved
                    ? Colors.green.shade700
                    : Colors.orange.shade700,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            widget.existingDocumentId != null
                ? "Edit Bill & Quotation"
                : "Bill & Quotation",
            style: AppTextStyles.appBarWhite21bold,
          ),
          backgroundColor: AppColors.themeBlue,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white),
              onPressed: _clearForm,
              tooltip: "Clear All",
            ), IconButton(
              icon: Icon(Icons.list_alt, color: Colors.white),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => BillQuotationListPage(),));
              },
              tooltip: "Clear All",
            ),

          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSaveStatusIndicator(), // Show save status
                _buildDocumentTypeSelector(),
                _buildCustomerDetailsForm(),
                _buildProductSelectionSection(),
                _buildManualProductForm(),
                if (_selectedProducts.isNotEmpty) ...[
                  _buildSelectedProductsList(),
                  SizedBox(height: 15),
                  _buildDiscountSection(),
                  SizedBox(height: 15),
                  _buildTotalAmount(),
                  SizedBox(height: 20),
                  if (!_isSaved || (_documentId != null && !_isSaved))
                    _buildSaveButton(),
                  if (_isSaved) _buildGenerateButtons(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTypeSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Document Type", style: AppTextStyles.black16bold),
          Row(
            children: [
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Bill'),
                  value: 'Bill',
                  groupValue: _documentType,
                  activeColor: AppColors.appColor,
                  onChanged: (v) {
                    setState(() => _documentType = v!);
                    _onDataChanged();
                  },
                ),
              ),
              Expanded(
                child: RadioListTile<String>(
                  title: Text('Quotation'),
                  value: 'Quotation',
                  groupValue: _documentType,
                  activeColor: AppColors.appColor,
                  onChanged: (v) {
                    setState(() => _documentType = v!);
                    _onDataChanged();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsForm() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Customer Details", style: AppTextStyles.black16bold),
          SizedBox(height: 10),
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: customerNameController,
            headingText: "Customer Name *",
            hintText: "Enter customer name",
            validator: (v) =>
                v == null || v.isEmpty ? "Please enter name" : null,
            inputFormatters: [UpperCaseTextFormatter()],
            onChanged: (_) => _onDataChanged(),
          ),
          SizedBox(height: 10),
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: customerMobileController,
            headingText: "Mobile Number *",
            hintText: "Enter mobile number",
            validator: (v) =>
                v == null || v.length != 10 ? "Enter 10 digit number" : null,
            keyboardType: TextInputType.phone,
            maxLength: 10,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => _onDataChanged(),
          ),
          AppTextFields.textFormFieldHeading(
            context: context,
            controller: customerEmailController,
            headingText: "Email ID",
            hintText: "Enter email id (optional)",
            onChanged: (_) => _onDataChanged(),
          ),
        ],
      ),
    );
  }

  Widget _buildProductSelectionSection() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Select Products", style: AppTextStyles.black16bold),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => setState(
                      () => _showProductSelection = !_showProductSelection,
                    ),
                    icon: Icon(
                      _showProductSelection
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    label: Text(
                      _showProductSelection ? "Hide Products" : "Show Products",
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_showProductSelection) ...[
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
            SizedBox(height: 10),
            Container(
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListView.separated(
                itemCount: _filteredProducts.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (_, i) {
                  var product = _filteredProducts[i];
                  return ListTile(
                    title: Text(product.name),
                    subtitle: Text('₹${product.price.toStringAsFixed(2)}'),
                    trailing: product.isSelected
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : ElevatedButton(
                            onPressed: () {
                              _addProductToSelected(product);
                              _onDataChanged();
                            },
                            child: Text(
                              "Add",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildManualProductForm() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Add Manual Product", style: AppTextStyles.black16bold),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: AppTextFields.textFormFieldHeading(
                  context: context,
                  controller: manualProductNameController,
                  headingText: "Product Name",
                  hintText: "Product name",
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: AppTextFields.textFormFieldHeading(
                  context: context,
                  controller: manualProductPriceController,
                  headingText: "Price",
                  hintText: "₹ Price",
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: AppTextFields.textFormFieldHeading(
                  context: context,
                  controller: manualProductQuantityController,
                  headingText: "Qty",
                  hintText: "1",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _addManualProduct();
                _onDataChanged();
              },
              icon: Icon(Icons.add, color: Colors.white),
              label: Text(
                "Add Manual Product",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProductsList() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Selected Products", style: AppTextStyles.black16bold),
          SizedBox(height: 10),
          Container(
            height: 280,

            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: MediaQuery.of(context).size.width * 1.3,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.grey.shade100,
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            child: Text(
                              "Product",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            width: 70,
                            child: Text(
                              "Price",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 90,
                            child: Text(
                              "Qty",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 70,
                            child: Text(
                              "Disc%",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 80,
                            child: Text(
                              "Total",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            width: 50,
                            child: Text(
                              "Action",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _selectedProducts.length,
                        itemBuilder: (context, i) {
                          var product = _selectedProducts[i];
                          return Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.grey.shade200),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  child: Text(
                                    product.name,
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),

                                Container(
                                  width: 70,
                                  child: Column(
                                    children: [
                                      if (product.discount > 0)
                                        Text(
                                          '₹${product.price.toInt()}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      Text(
                                        '₹${product.discountedPrice.toInt()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 90,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          if (product.quantity > 1) {
                                            _updateProductQuantityWithChange(
                                              i,
                                              product.quantity - 1,
                                            );
                                          }
                                        },
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade100,
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.remove,
                                            size: 14,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5,),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                        ),
                                        child: Text(
                                          "${product.quantity}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),         SizedBox(width: 5,),
                                      InkWell(
                                        onTap: () =>
                                            _updateProductQuantityWithChange(
                                              i,
                                              product.quantity + 1,
                                            ),
                                        child: Container(
                                          width: 18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            size: 14,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 70,
                                  child: Container(
                                    height: 32,
                                    child: TextFormField(
                                      initialValue: product.discount.toString(),
                                      keyboardType: TextInputType.number,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 14),
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4,
                                          vertical: 2,
                                        ),
                                        suffix: Text(
                                          '%',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        double discount =
                                            double.tryParse(value) ?? 0.0;
                                        if (discount >= 0 && discount <= 100) {
                                          _updateProductDiscountWithChange(
                                            i,
                                            discount,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ),

                                Container(
                                  width: 80,
                                  child: Column(
                                    children: [
                                      Text(
                                        '₹${product.total.toInt()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (product.discount > 0)
                                        Text(
                                          'Save ₹${product.discountAmount.toInt()}',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 50,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    onPressed: () {
                                      _removeProductFromSelected(i);
                                      _onDataChanged();
                                    },
                                    padding: EdgeInsets.all(2),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountSection() {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Overall Discount",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              Text(
                "$_customerType Customer",
                style: TextStyle(
                  color: AppColors.appColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPercentageDiscount = true;
                      discountController.text = _overallDiscountPercentage
                          .toString();
                    });
                    _onDataChanged();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _isPercentageDiscount
                          ? AppColors.appColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: _isPercentageDiscount
                            ? AppColors.appColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _isPercentageDiscount
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: _isPercentageDiscount
                              ? AppColors.appColor
                              : Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Percentage",
                          style: TextStyle(
                            fontSize: 12,
                            color: _isPercentageDiscount
                                ? AppColors.appColor
                                : Colors.grey[600],
                            fontWeight: _isPercentageDiscount
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isPercentageDiscount = false;
                      discountController.text = _overallDiscountAmount
                          .toString();
                    });
                    _onDataChanged();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: !_isPercentageDiscount
                          ? AppColors.appColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: !_isPercentageDiscount
                            ? AppColors.appColor
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          !_isPercentageDiscount
                              ? Icons.radio_button_checked
                              : Icons.radio_button_unchecked,
                          size: 16,
                          color: !_isPercentageDiscount
                              ? AppColors.appColor
                              : Colors.grey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          "Fixed Amount",
                          style: TextStyle(
                            fontSize: 12,
                            color: !_isPercentageDiscount
                                ? AppColors.appColor
                                : Colors.grey[600],
                            fontWeight: !_isPercentageDiscount
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10),

          TextFormField(
            controller: discountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.appColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: AppColors.appColor, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              prefixText: _isPercentageDiscount ? null : '₹ ',
              suffixText: _isPercentageDiscount ? ' %' : null,
              hintText: _isPercentageDiscount
                  ? "Enter percentage"
                  : "Enter amount",
              hintStyle: TextStyle(fontSize: 14),
              fillColor: Colors.white,
              filled: true,
            ),
            onChanged: _updateOverallDiscountWithChange,
            validator: (value) {
              if (value == null || value.isEmpty) return null;

              double? val = double.tryParse(value);
              if (val == null) return 'Enter valid number';

              if (_isPercentageDiscount && val > 100) {
                return 'Percentage cannot exceed 100%';
              }

              if (!_isPercentageDiscount && val > afterProductDiscountAmount) {
                return 'Amount exceeds remaining total';
              }

              return null;
            },
          ),

          SizedBox(height: 10),

          if (overallDiscountAmount > 0)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _isPercentageDiscount
                        ? "Discount ($_overallDiscountPercentage%)"
                        : "Fixed Discount",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "- ₹${overallDiscountAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTotalAmount() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.appColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.appColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Subtotal:", style: TextStyle(fontSize: 14)),
              Text(
                "₹${subtotalAmount.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
          if (productDiscountAmount > 0) ...[
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Product Discount:",
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
                Text(
                  "- ₹${productDiscountAmount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
              ],
            ),
          ],
          if (overallDiscountAmount > 0) ...[
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Overall Discount:",
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
                Text(
                  "- ₹${overallDiscountAmount.toStringAsFixed(2)}",
                  style: TextStyle(fontSize: 12, color: Colors.orange),
                ),
              ],
            ),
          ],
          Divider(thickness: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Final Amount:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appColor,
                ),
              ),
              Text(
                "₹${totalAmount.toStringAsFixed(2)}",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appColor,
                ),
              ),
            ],
          ),
          if (totalSavings > 0) ...[
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Savings:",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "₹${totalSavings.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: ElevatedButton.icon(
        onPressed: _saveData,
        icon: Icon(Icons.save, color: Colors.white),
        label: Text(
          _documentId != null ? "Update Data" : "Save Data",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: _documentId != null ? Colors.blue : Colors.orange,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildGenerateButtons() {
    return Column(
      children: [
        Center(
          child: ElevatedButton.icon(
            onPressed: () => _generateDocument(_documentType),
            icon: Icon(
              _documentType == 'Bill' ? Icons.receipt : Icons.picture_as_pdf,
              color: Colors.white,
            ),
            label: Text(
              "Generate $_documentType PDF",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: _documentType == 'Bill'
                  ? Colors.blue
                  : AppColors.appColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade300),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Data saved successfully!",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                "Document ID: $_documentId",
                style: TextStyle(
                  color: Colors.green.shade600,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Click to generate $_documentType PDF.",
                style: TextStyle(color: Colors.green.shade700, fontSize: 12),
              ),
              if (totalSavings > 0)
                Text(
                  "Customer saves ₹${totalSavings.toStringAsFixed(2)} total!",
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
