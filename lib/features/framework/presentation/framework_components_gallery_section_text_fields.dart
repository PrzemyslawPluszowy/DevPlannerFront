part of 'framework_components_gallery_page.dart';

extension _TextFieldsSection on _FrameworkComponentsGalleryPageState {
  Widget _buildTextFieldsSection(AppControlSize controlSize) {
    return _GallerySection(
      title: 'Text Fields',
      subtitle: 'Kompaktowe pola formularzowe pod ekrany CRM.',
      codeSnippet: '''
AppTextField(
  labelText: 'Nazwa klienta',
  isRequired: true,
  hintText: 'Wpisz nazwe',
)
''',
      child: Wrap(
        spacing: Sizes.p12,
        runSpacing: Sizes.p12,
        children: [
          SizedBox(
            width: 280,
            child: AppTextField(
              controller: customerNameController,
              labelText: 'Nazwa klienta',
              isRequired: true,
              hintText: 'Wpisz nazwę',
              prefixIcon: Icons.business_outlined,
            ),
          ),
          SizedBox(
            width: 280,
            child: AppTextField(
              controller: customerEmailController,
              labelText: 'E-mail',
              isRequired: true,
              hintText: 'mail@firma.pl',
              prefixIcon: Icons.alternate_email_rounded,
              keyboardType: .emailAddress,
              textInputAction: .next,
            ),
          ),
          const SizedBox(
            width: 280,
            child: AppTextField(
              labelText: 'Telefon',
              hintText: '+48 000 000 000',
              prefixIcon: Icons.phone_outlined,
              keyboardType: .phone,
              errorText: 'Niepoprawny numer',
            ),
          ),
          SizedBox(
            width: 280,
            child: AppTextField(
              controller: customerNoteController,
              labelText: 'Notatka',
              hintText: 'Dodatkowe informacje...',
              size: controlSize,
              maxLines: 3,
              minLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
