import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:litera/app/data/models/category_model.dart';
import 'package:litera/app/data/models/product_model.dart';
import '../controllers/admin_produk_controller.dart';

class ProductFormView extends StatefulWidget {
  final ProductModel? product;

  const ProductFormView({super.key, this.product});

  @override
  State<ProductFormView> createState() => _ProductFormViewState();
}

class _ProductFormViewState extends State<ProductFormView> {
  final _formKey = GlobalKey<FormState>();
  final AdminProdukController controller = Get.find<AdminProdukController>();

  late TextEditingController titleCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController stockCtrl;
  late TextEditingController descCtrl;
  late TextEditingController authorCtrl;
  late TextEditingController langCtrl;
  late TextEditingController pagesCtrl;
  late TextEditingController publishedAtCtrl;

  int? selectedCategoryId;
  File? selectedImageFile;
  PlatformFile? selectedPdfFile;

  final NumberFormat _currencyDisplay = NumberFormat.decimalPattern('id_ID');

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;

    selectedCategoryId = p?.categoryId;
    titleCtrl = TextEditingController(text: p?.title ?? '');
    priceCtrl = TextEditingController(
      text: p != null ? _currencyDisplay.format(p.price.toInt()) : '',
    );
    stockCtrl = TextEditingController(text: p?.stock.toString() ?? '');
    descCtrl = TextEditingController(text: p?.description ?? '');
    authorCtrl = TextEditingController(text: p?.author ?? '');
    langCtrl = TextEditingController(text: p?.language ?? '');
    pagesCtrl = TextEditingController(text: p?.pages ?? '');
    
    // Convert published date from backend format (yyyy-MM-dd) to display format (dd MMM yyyy)
    publishedAtCtrl = TextEditingController(
      text: p?.publishedAt != null 
          ? _convertBackendDateToDisplayFormat(p!.publishedAt)
          : '',
    );

    if (controller.categories.isEmpty) {
      controller.fetchCategories().then((_) {
        _validateCategorySelection();
      });
    } else {
      _validateCategorySelection();
    }
  }

  void _validateCategorySelection() {
    // Check if selectedCategoryId is in the available categories
    if (selectedCategoryId != null) {
      final categoryExists = controller.categories.any(
        (cat) => cat.id == selectedCategoryId,
      );
      if (!categoryExists) {
        setState(() {
          selectedCategoryId = null;
        });
      }
    }
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    priceCtrl.dispose();
    stockCtrl.dispose();
    descCtrl.dispose();
    authorCtrl.dispose();
    langCtrl.dispose();
    pagesCtrl.dispose();
    publishedAtCtrl.dispose();
    super.dispose();
  }

  String _generateSlug(String text) {
    return text
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-');
  }

  double _parseRupiah(String input) {
    final digitsOnly = input.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) return 0;
    return double.tryParse(digitsOnly) ?? 0;
  }

  void _formatPriceInput(String value) {
    final digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digitsOnly.isEmpty) {
      priceCtrl.value = const TextEditingValue(text: '');
      return;
    }

    final formatted = _currencyDisplay.format(int.parse(digitsOnly));
    priceCtrl.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      final file = File(picked.path);
      final fileSizeInMB = (file.lengthSync()) / (1024 * 1024);

      // Check if image is too large (backend max 2MB)
      if (fileSizeInMB > 2) {
        Get.snackbar(
          'Image Too Large',
          'Image is ${fileSizeInMB.toStringAsFixed(2)} MB (max 2 MB).\nPlease select a smaller image.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFE74C3C),
          colorText: Colors.white,
        );
        return;
      }

      setState(() {
        selectedImageFile = file;
      });
    }
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: false,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      final fileSizeInMB = (file.size) / (1024 * 1024);

      // Warn if file is large
      if (fileSizeInMB > 10) {
        Get.snackbar(
          'File Too Large',
          'PDF file is ${fileSizeInMB.toStringAsFixed(2)} MB.\nRecommended max 10 MB for faster upload.\nContinue anyway?',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 7),
          mainButton: TextButton(
            onPressed: () {
              setState(() {
                selectedPdfFile = file;
              });
              Get.back();
            },
            child: const Text('Yes, Use It'),
          ),
        );
        return;
      }

      setState(() {
        selectedPdfFile = file;
      });
    }
  }

  Future<void> _pickPublishedDate() async {
    DateTime initialDate = DateTime.now();

    // Parse display format (dd MMM yyyy) back to DateTime for picker
    if (publishedAtCtrl.text.trim().isNotEmpty) {
      try {
        final displayDate = DateFormat('dd MMM yyyy', 'id_ID').parse(publishedAtCtrl.text.trim());
        initialDate = displayDate;
      } catch (e) {
        // Fallback to trying yyyy-MM-dd format for existing data
        initialDate = DateTime.tryParse(publishedAtCtrl.text.trim()) ?? DateTime.now();
      }
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      // Store in display format (dd MMM yyyy) but backend expects yyyy-MM-dd
      publishedAtCtrl.text = DateFormat('dd MMM yyyy', 'id_ID').format(picked);
    }
  }

  String _convertBackendDateToDisplayFormat(String backendDate) {
    try {
      // Parse backend format (yyyy-MM-dd) to DateTime
      final date = DateTime.tryParse(backendDate.trim());
      if (date == null) return backendDate.trim();
      // Format to display format (dd MMM yyyy)
      return DateFormat('dd MMM yyyy', 'id_ID').format(date);
    } catch (e) {
      return backendDate.trim();
    }
  }

  String _convertDisplayDateToBackendFormat(String displayDate) {
    try {
      // Parse display format (dd MMM yyyy) to DateTime
      final date = DateFormat('dd MMM yyyy', 'id_ID').parse(displayDate.trim());
      // Format back to backend format (yyyy-MM-dd)
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      // If already in yyyy-MM-dd format, return as is
      return displayDate.trim();
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    if (selectedCategoryId == null) {
      Get.snackbar(
        'Validation',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Validate PDF is required for new products
    if (widget.product == null && selectedPdfFile == null) {
      Get.snackbar(
        'Validation',
        'PDF file is required for new products',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFE74C3C),
        colorText: Colors.white,
      );
      return;
    }

    final newProduct = ProductModel(
      id: widget.product?.id ?? 0,
      categoryId: selectedCategoryId!,
      category: widget.product?.category,
      title: titleCtrl.text.trim(),
      slug: _generateSlug(titleCtrl.text),
      price: _parseRupiah(priceCtrl.text),
      description: descCtrl.text.trim().isEmpty ? null : descCtrl.text.trim(),
      fileBook: widget.product?.fileBook,
      stock: int.tryParse(stockCtrl.text) ?? 0,
      image: widget.product?.image,
      author: authorCtrl.text.trim(),
      language: langCtrl.text.trim(),
      pages: pagesCtrl.text.trim(),
      publishedAt: _convertDisplayDateToBackendFormat(publishedAtCtrl.text),
    );

    controller.saveProduct(
      newProduct,
      imageFile: selectedImageFile,
      pdfFile: selectedPdfFile,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Product' : 'Add Product'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1A1A2E),
      ),
      body: Obx(
        () => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildSectionCard(
                title: 'Basic Information',
                icon: Icons.inventory_2_outlined,
                children: [
                  _buildCategoryDropdown(),
                  const SizedBox(height: 16),
                  _buildTextField('Title', titleCtrl),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildPriceField()),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'Stock',
                          stockCtrl,
                          isNumber: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Description',
                    descCtrl,
                    maxLines: 4,
                    required: false,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Book Details',
                icon: Icons.menu_book_outlined,
                children: [
                  _buildTextField('Author', authorCtrl),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _buildTextField('Language', langCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTextField('Pages', pagesCtrl)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(),
                ],
              ),
              const SizedBox(height: 16),
              _buildSectionCard(
                title: 'Files',
                icon: Icons.attach_file_outlined,
                children: [
                  _buildImagePickerCard(),
                  const SizedBox(height: 12),
                  _buildPdfPickerCard(),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.isLoading.value ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90E2),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        isEdit ? 'Save Changes' : 'Create Product',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A90E2).withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF4A90E2)),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          ...children,
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    // Get list of valid category ids
    final validIds = controller.categories.map((cat) => cat.id).toSet();

    // Only use selectedCategoryId if it exists in the valid list
    final validValue =
        selectedCategoryId != null && validIds.contains(selectedCategoryId)
        ? selectedCategoryId
        : null;

    return DropdownButtonFormField<int>(
      initialValue: validValue,
      decoration: _inputDecoration('Category'),
      items: controller.categories.map((CategoryModel category) {
        return DropdownMenuItem<int>(
          value: category.id,
          child: Text(category.name),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedCategoryId = value;
        });
      },
      validator: (value) {
        if (value == null || value == 0) return 'Category is required';
        return null;
      },
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: priceCtrl,
      keyboardType: TextInputType.number,
      onChanged: _formatPriceInput,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Required';
        }
        if (_parseRupiah(val) <= 0) {
          return 'Invalid price';
        }
        return null;
      },
      decoration: _inputDecoration('Price').copyWith(prefixText: 'Rp '),
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: publishedAtCtrl,
      readOnly: true,
      onTap: _pickPublishedDate,
      validator: (val) {
        if (val == null || val.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: _inputDecoration('Published At').copyWith(
        suffixIcon: IconButton(
          onPressed: _pickPublishedDate,
          icon: const Icon(Icons.calendar_month_outlined),
        ),
      ),
    );
  }

  Widget _buildImagePickerCard() {
    final hasLocalImage = selectedImageFile != null;
    final hasNetworkImage =
        widget.product?.image != null && widget.product!.image!.isNotEmpty;

    Widget preview;
    if (hasLocalImage) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          selectedImageFile!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (hasNetworkImage &&
        (widget.product!.image!.startsWith('http://') ||
            widget.product!.image!.startsWith('https://'))) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          widget.product!.image!,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      preview = Container(
        height: 140,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE3E8F0)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.image_outlined, size: 40, color: Color(0xFF4A90E2)),
            SizedBox(height: 8),
            Text('No image selected'),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        preview,
        const SizedBox(height: 10),
        OutlinedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo_library_outlined),
          label: Text(hasLocalImage ? 'Change Image' : 'Pick Image'),
        ),
      ],
    );
  }

  Widget _buildPdfPickerCard() {
    final pdfName =
        selectedPdfFile?.name ??
        (widget.product?.fileBook != null &&
                widget.product!.fileBook!.isNotEmpty
            ? widget.product!.fileBook!
            : null);

    final isNewProduct = widget.product == null;
    final isPdfSelected = selectedPdfFile != null || pdfName != null;
    final pdfSizeMB = selectedPdfFile != null
        ? (selectedPdfFile!.size) / (1024 * 1024)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'PDF File',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            if (isNewProduct)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBFE),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isNewProduct && !isPdfSelected
                  ? Colors.red.withValues(alpha: 0.5)
                  : const Color(0xFFE3E8F0),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.picture_as_pdf_outlined,
                color: Colors.redAccent,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pdfName ?? 'No PDF selected',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isNewProduct && !isPdfSelected
                            ? Colors.red
                            : null,
                      ),
                    ),
                    if (pdfSizeMB != null)
                      Text(
                        '${pdfSizeMB.toStringAsFixed(2)} MB',
                        style: TextStyle(
                          fontSize: 12,
                          color: pdfSizeMB > 10
                              ? Colors.orange
                              : Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              OutlinedButton(
                onPressed: _pickPdf,
                child: const Text('Choose PDF'),
              ),
            ],
          ),
        ),
        if (isNewProduct && !isPdfSelected)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              'PDF is required for new products',
              style: TextStyle(color: Colors.red[600], fontSize: 12),
            ),
          ),
        if (pdfSizeMB != null && pdfSizeMB > 10)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '⚠ File is ${pdfSizeMB.toStringAsFixed(2)} MB. Recommended max 10 MB.',
              style: TextStyle(color: Colors.orange[600], fontSize: 12),
            ),
          ),
      ],
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController ctrl, {
    bool isNumber = false,
    int maxLines = 1,
    bool required = true,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: false)
          : TextInputType.text,
      maxLines: maxLines,
      validator: (val) {
        if (!required) return null;
        if (val == null || val.trim().isEmpty) {
          return 'Required';
        }
        return null;
      },
      decoration: _inputDecoration(label),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: const Color(0xFFF7F9FC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE3E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFFE3E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 1.4),
      ),
    );
  }
}
