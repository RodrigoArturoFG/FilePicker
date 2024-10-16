//
//  PhotoPicker.swift
//  FilePicker
//
//  Created by Fernández González Rodrigo Arturo on 15/10/24.
//

import SwiftUI
import PhotosUI


struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var isPhotoPickerPresented: Bool
    @Binding var data: Data?
    //@Binding var image: UIImage?
    
    @Binding var presentImageAlert: Bool
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your PHPickerViewControllerDelegate
    class Coordinator: PHPickerViewControllerDelegate {
        
        private let parent: PhotoPicker
        
        init(_ parent: PhotoPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print(results)
            parent.isPhotoPickerPresented = false
            guard let provider = results.first?.itemProvider else {  return }
            
            DispatchQueue.main.async {
                if provider.canLoadObject(ofClass: UIImage.self) {
                    
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        if(error != nil){
                            self.parent.presentImageAlert = true
                            print(error?.localizedDescription as Any)
                        }else{
                            let image = image as? UIImage
                            self.parent.data = image?.jpegData(compressionQuality: 1)
                        }
                    }
                }
            }
        }
    }
}
