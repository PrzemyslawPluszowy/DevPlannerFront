/// Minimalny kontrakt draftu używany przez ownera załączników composera.
///
/// Oddziela lifecycle sesji uploadu od widgetu i od konkretnego Cubita
/// composera. Implementacja może dodatkowo utrwalić zmianę draftu.
typedef ChatAttachmentDraftUpdater = void Function(List<String> attachmentIds);
