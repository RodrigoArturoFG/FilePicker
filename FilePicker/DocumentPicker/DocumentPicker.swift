//
//  DocumentPicker.swift
//  FilePicker
//
//  Created by Fernández González Rodrigo Arturo on 15/10/24.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var isFilePickerPresented: Bool
    @Binding var documentData: Data?
    //@Binding var filePath: URL?
    
    @Binding var presentDocumentAlert: Bool

    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        controller.allowsMultipleSelection = false
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Use a Coordinator to act as your UIDocumentPickerDelegate
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        
        private let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            let filePath: URL?
            
            parent.isFilePickerPresented = false
            filePath = urls[0]
            print(urls[0].absoluteString)
                        
            if (filePath != nil) {
                do {
                    let fileData = try Data(contentsOf: filePath! as URL)
                    print(fileData)
                    self.parent.documentData = fileData
                } catch {
                    print("No se pueden cargar los datos: \(error)")
                    self.parent.presentDocumentAlert = true
                }
            }
        }
    }
}
