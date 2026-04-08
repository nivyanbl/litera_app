import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:litera/app/core/theme/app_colors.dart';
import 'package:litera/app/core/widgets/custom_app_bar.dart';
import 'package:litera/app/core/widgets/custom_text_field.dart';
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
        final displayDate = DateFormat(
          'dd MMM yyyy',
          'id_ID',
        ).parse(publishedAtCtrl.text.trim());
        initialDate = displayDate;
      } catch (e) {
        // Fallback to trying yyyy-MM-dd format for existing data
        initialDate =
            DateTime.tryParse(publishedAtCtrl.text.trim()) ?? DateTime.now();
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
      backgroundColor: AppColors.grayLight,
      appBar: CustomAppBar(
        title: isEdit ? 'Edit Product' : 'Add Product',
        showLeftIcon: true,
        showRightIcon: false,
      ),
      body: Obx(
        () => Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                    minLines: 4,
                    required: false,
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 20),
              _buildSectionCard(
                title: 'Files',
                icon: Icons.attach_file_outlined,
                children: [
                  _buildImagePickerCard(),
                  const SizedBox(height: 16),
                  _buildPdfPickerCard(),
                ],
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryNormal,
                    disabledBackgroundColor: AppColors.grayLightHover,
                    disabledForegroundColor: AppColors.grayLightActive,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : Text(
                          isEdit ? 'Save Changes' : 'Create Product',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.primaryNormal, size: 22),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.grayDarker,
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
    final validIds = controller.categories.map((cat) => cat.id).toSet();
    final validValue =
        selectedCategoryId != null && validIds.contains(selectedCategoryId)
        ? selectedCategoryId
        : null;

    return CustomDropdownField<int>(
      hintText: 'Category',
      value: validValue,
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
      isRequired: true,
    );
  }

  Widget _buildPriceField() {
    return CustomTextField(
      hintText: 'Price',
      controller: priceCtrl,
      keyboardType: TextInputType.number,
      prefixText: 'Rp ',
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
      isRequired: true,
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
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          selectedImageFile!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else if (hasNetworkImage &&
        (widget.product!.image!.startsWith('http://') ||
            widget.product!.image!.startsWith('https://'))) {
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          widget.product!.image!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    } else {
      preview = Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grayLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.grayLightActive, width: 0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: AppColors.primaryNormal,
                size: 24,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'No cover image selected',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.grayDarker,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              'JPG, PNG • Max 2 MB',
              style: TextStyle(fontSize: 11, color: AppColors.grayNormal),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        preview,
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _pickImage,
            icon: Icon(
              hasLocalImage ? Icons.loop : Icons.add_a_photo_outlined,
              size: 18,
            ),
            label: Text(
              hasLocalImage ? 'Change Cover Image' : 'Upload Cover Image',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryNormal,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
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
            const Text(
              'Book Content (PDF)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.grayDarker,
              ),
            ),
            if (isNewProduct)
              const Text(
                ' *',
                style: TextStyle(
                  color: AppColors.errorNormal,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.grayLightActive, width: 0.8),
          ),
          child: Row(
            children: [
              Container(
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFFBEAEA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_outlined,
                  color: AppColors.errorNormal,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      pdfName ?? 'No PDF selected',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grayDarker,
                      ),
                    ),
                    if (pdfSizeMB != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          '${pdfSizeMB.toStringAsFixed(2)} MB',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.grayNormal,
                          ),
                        ),
                      ),
                    if (!isPdfSelected)
                      const Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: Text(
                          'Upload a PDF file',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.grayNormal,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: _pickPdf,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isPdfSelected ? 'Replace' : 'Upload',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryNormal,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isNewProduct && !isPdfSelected)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 14,
                  color: AppColors.errorNormal,
                ),
                const SizedBox(width: 6),
                Text(
                  'PDF is required for new products',
                  style: const TextStyle(
                    color: AppColors.errorNormal,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        if (pdfSizeMB != null && pdfSizeMB > 10)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  Icons.warning_outlined,
                  size: 14,
                  color: AppColors.warningNormal,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'File is ${pdfSizeMB.toStringAsFixed(2)} MB (max 10 MB recommended)',
                    style: const TextStyle(
                      color: AppColors.warningNormal,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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
    int minLines = 1,
    bool required = true,
  }) {
    return CustomTextField(
      hintText: label,
      controller: ctrl,
      keyboardType: isNumber
          ? const TextInputType.numberWithOptions(decimal: false)
          : TextInputType.text,
      maxLines: maxLines,
      minLines: minLines,
      isRequired: required,
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grayLightActive),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.grayLightActive),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryNormal,
          width: 1.2,
        ),
      ),
      labelStyle: const TextStyle(color: AppColors.grayNormal, fontSize: 13),
    );
  }
}
