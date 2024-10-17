//
//  ContentView.swift
//  FilePicker
//
//  Created by Fernández González Rodrigo Arturo on 15/10/24.
//

import SwiftUI

struct ContentView: View {
    
    // MARK: Variables necesarias en la vista para el metodo Seleccionar Imagen
    @State private var isPhotoPickerPresented: Bool = false
    @State private var inputImage: UIImage?
    //@State private var inputData: Data?

    @State private var presentImageAlert: Bool = false
    @State private var messageImageAlert = "Ocurrio un error al cargar la imagen"
    
    // MARK: PlaceHolder de la imagen
    @State private var image = Image(systemName:"photo.on.rectangle.angled")
    
    // MARK: Variables necesarias en la vista para el metodo Seleccionar documentos (PDF)
    @State private var isFilePickerPresented: Bool = false
    @State private var documentData: Data?
    @State private var documentSize: String?
    //@State private var filePath: URL?
    
    @State private var presentDocumentAlert: Bool = false
    @State private var messageDocumentAlert = "Ocurrio un error al cargar el documento"
    
    var body: some View {
        VStack {
            
            // MARK: Seleccionar Imagen
            
            // Al usar PHPicker, No se requiere solicitar al usuario el acceso a su biblioteca de fotografías.
            // De acuerdo con Apple: "It has privacy built in by default. It doesn't need direct access to the photos library to show the picker and the picker won't prompt for access on behalf of the app." - https://developer.apple.com/videos/play/wwdc2020/10652/
            
            Button("Seleccionar Imagen") {
                isPhotoPickerPresented.toggle()
            }.sheet(isPresented: $isPhotoPickerPresented) {
                PhotoPicker(isPhotoPickerPresented: $isPhotoPickerPresented, image:$inputImage, presentImageAlert: $presentImageAlert)
            }.onChange(of: inputImage) { _ in
                presentImageAlert = false
                guard let inputImage = inputImage else { return }
                image = Image(uiImage: inputImage)
                /*
                guard let inputData = inputData else { return }
                guard let imageParsed = UIImage(data: inputData) else { return }
                image = Image(uiImage: imageParsed)*/
            }.alert(isPresented: $presentImageAlert) {
                Alert(
                    title: Text("Error Imagen"),
                    message: Text(messageImageAlert),
                    dismissButton: .default(Text("Ok"), action: {
                        presentImageAlert.toggle()
                    })
                )
            }.padding()
            
            // MARK: Image View - Contenedor de la imágen seleccionada
            image.resizable()
                .scaledToFill()
                .frame(width: 107, height: 107)
                .padding()
            
            // MARK: Seleccionar Documento
            
            // Al usar UIDocumentPickerViewController, tampoco se requiere solicitar al usuario el acceso al directorio del sipositivo.
            // De acuerdo con Apple: In iOS 13, users can select a directory from any of the available file providers using a UIDocumentPickerViewController. The document picker returns a security-scoped URL for the directory that permits your app to access content outside its container.
            // When the user selects a directory in the document picker, the system gives your app permission to access that directory and all of its contents. The document picker returns a security-scoped URL for the directory. - https://developer.apple.com/documentation/uikit/view_controllers/providing_access_to_directories
            
            Button("Seleccionar Documentos") {
                isFilePickerPresented.toggle()
            }.sheet(isPresented: $isFilePickerPresented) {
                // Presentar el Document Picker
                DocumentPicker(isFilePickerPresented: $isFilePickerPresented, documentData: $documentData, presentDocumentAlert: $presentDocumentAlert)
            }.onChange(of: documentData) { _ in
                // Se obtuvo la Data del documento seleccionado
                // Manejo de la respuesta
                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
                bcf.countStyle = .file
                self.documentSize = bcf.string(fromByteCount: Int64(documentData!.count))
            }.alert(isPresented: $presentDocumentAlert) {
                // Ocurrió un error al seleccionar un documento
                Alert(
                    title: Text("Error Documento"),
                    message: Text(messageDocumentAlert),
                    dismissButton: .default(Text("Ok"), action: {
                        presentDocumentAlert.toggle()
                    })
                )
            }.padding()
            
            Text("Data: " + (self.documentSize ?? "0 KB"))
                .foregroundColor(.secondary)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

