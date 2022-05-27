import PhotosUI
import SwiftUI

public struct PhotoPicker: UIViewControllerRepresentable {
  let configuration: PHPickerConfiguration

  @Binding var images: [UIImage]

  @Environment(\.dismiss) private var dismiss

  public init(configuration: PHPickerConfiguration, images: Binding<[UIImage]>) {
    self.configuration = configuration
    self._images = images
  }

  public func makeUIViewController(context: Context) -> some UIViewController {
    let controller = PHPickerViewController(configuration: configuration)
    controller.delegate = context.coordinator
    return controller
  }

  public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
  }

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

extension PhotoPicker {
  public class Coordinator: PHPickerViewControllerDelegate {
    private let parent: PhotoPicker

    init(_ parent: PhotoPicker) {
      self.parent = parent
    }

    public func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
      parent.images.removeAll()

      results.forEach { result in
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
          result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            if let error = error {
              print(error.localizedDescription)
            } else if let image = image as? UIImage {
              DispatchQueue.main.async {
                self?.parent.images.append(image)
              }
            }
          }
        } else {
          print("Can't load image")
        }
      }

      // dismiss the picker
      parent.dismiss()
    }
  }
}

extension PhotoPicker {
  public static var singlePhotoConfiguration: PHPickerConfiguration {
    var config = PHPickerConfiguration(photoLibrary: .shared())
    config.filter = .images
    config.selectionLimit = 1
    return config
  }
}
