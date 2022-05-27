import PhoneNumberKit
import SwiftUI

public struct PhoneNumberField: UIViewRepresentable {
  @Binding public var text: String
  @Binding public var isValid: Bool

  private var externalIsFirstResponder: Binding<Bool>?
  // This variable is used only if an `isEditing` binding was not provided in the initializer.
  @State private var internalIsFirstResponder = false

  private var isFirstResponder: Bool {
    get { externalIsFirstResponder?.wrappedValue ?? internalIsFirstResponder }
    set {
      if externalIsFirstResponder != nil {
        externalIsFirstResponder?.wrappedValue = newValue
      } else {
        internalIsFirstResponder = newValue
      }
    }
  }

  var font: UIFont?
  var textColor: UIColor?
  var isUserInteractionEnabled = true

  public init(
    text: Binding<String>,
    isValid: Binding<Bool>,
    isEditing: Binding<Bool>? = nil
  ) {
    self._text = text
    self._isValid = isValid
    self.externalIsFirstResponder = isEditing
  }

  public func makeUIView(context: Context) -> WrappedPhoneNumberTextField {
    let phoneNumberKit: PhoneNumberKit = .init(metadataCallback: PhoneNumberKit.bundleMetadataCallback)
    let field = WrappedPhoneNumberTextField(withPhoneNumberKit: phoneNumberKit)

    field.setContentHuggingPriority(.defaultHigh, for: .vertical)
    field.addTarget(
      context.coordinator,
      action: #selector(Coordinator.textViewDidChange),
      for: .editingChanged
    )
    field.maxDigits = 10
    field.withPrefix = false


    return field
  }

  public func updateUIView(_ uiView: WrappedPhoneNumberTextField, context: Context) {
    DispatchQueue.main.async {
      if uiView.window != nil {
        uiView.textContentType = .telephoneNumber
        uiView.font = font
        uiView.textColor = textColor
        uiView.isUserInteractionEnabled = isUserInteractionEnabled


        if isFirstResponder {
          uiView.becomeFirstResponder()
        } else {
          uiView.resignFirstResponder()
        }
      }
    }
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(
      text: $text,
      isValid: $isValid,
      isFirstResponder: externalIsFirstResponder ?? $internalIsFirstResponder
    )
  }
}

extension PhoneNumberField {
  public final class WrappedPhoneNumberTextField: PhoneNumberTextField {
    public override var defaultRegion: String {
      get { "US" }
      set { self.partialFormatter.defaultRegion = newValue }
    }
  }
}

extension PhoneNumberField {
  public final class Coordinator: NSObject, UITextFieldDelegate {
    private var text: Binding<String>
    private var isValid: Binding<Bool>
    private var isFirstResponder: Binding<Bool>
    init(
      text: Binding<String>,
      isValid: Binding<Bool>,
      isFirstResponder: Binding<Bool>
    ) {
      self.text = text
      self.isValid = isValid
      self.isFirstResponder = isFirstResponder
    }

    @objc public func textViewDidChange(_ textField: UITextField) {
      guard let textField = textField as? WrappedPhoneNumberTextField else {
        return assertionFailure("Undefined state")
      }
      if text.wrappedValue != textField.text {
        text.wrappedValue = textField.text ?? ""
      }

      if isValid.wrappedValue != textField.isValidNumber {
        isValid.wrappedValue = textField.isValidNumber
      }
    }

    public func textFieldDidBeginEditing(_ textField: UITextField) {
      isFirstResponder.wrappedValue = true
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
      isFirstResponder.wrappedValue = false
    }
  }
}

extension PhoneNumberKit {
  public static func bundleMetadataCallback() throws -> Data? {
    guard
      let jsonPath = Bundle.module.path(forResource: "PhoneNumberMetadata", ofType: "json")
    else { throw PhoneNumberError.metadataNotFound }
    return try Data(contentsOf: URL(fileURLWithPath: jsonPath))
  }
}

// MARK: - View Modifiers

public extension PhoneNumberField {
  func font(_ font: UIFont?) -> Self {
    var view = self
    view.font = font
    return view
  }

  func disabled(_ disabled: Bool) -> Self {
    var view = self
    view.isUserInteractionEnabled = !disabled
    return view
  }

  @available(iOS 14, *)
  func foregroundColor(_ color: Color?) -> Self {
    if let color = color {
      return foregroundColor(UIColor(color))
    } else {
      return nilForegroundColor()
    }
  }

  func foregroundColor(_ color: CGColor?) -> Self {
    if let color = color {
      return foregroundColor(UIColor(cgColor: color))
    } else {
      return nilForegroundColor()
    }
  }

  func foregroundColor(_ color: UIColor?) -> Self {
    var view = self
    view.textColor = color
    return view
  }

  private func nilForegroundColor() -> Self {
    var view = self
    view.textColor = nil
    return view
  }
}
