//
//  ContentView.swift
//  FilePicker
//
//  Created by Fernández González Rodrigo Arturo on 15/10/24.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    // MARK: Variables necesarias en la vista para el metodo Seleccionar Imagen
    @State private var isPhotoPickerPresented: Bool = false
    @State private var inputData: Data?
    //@State private var inputImage: UIImage?
    
    @State private var presentImageAlert: Bool = false
    @State private var messageImageAlert = "Ocurrio un error al cargar la imagen"
    
    // MARK: Variables necesarias en la vista para el metodo Seleccionar documentos (PDF)
    @State private var isFilePickerPresented: Bool = false
    @State private var documentData: Data?
    @State private var documentSize: String?
    //@State private var filePath: URL?
    
    @State private var presentDocumentAlert: Bool = false
    @State private var messageDocumentAlert = "Ocurrio un error al cargar el documento"
    
    // MARK: PlaceHolder de la imagen
    @State private var image = Image("AppCDMXDummy")
    
    var body: some View {
        VStack {
            
            Button("Seleccionar Imagen") {
                // Al usar PHPicker, No se requiere acceso directo a la biblioteca de fotografías del usuario. De acuerdo con Apple: "It has privacy built in by default. It doesn't need direct access to the photos library to show the picker and the picker won't prompt for access on behalf of the app." - https://developer.apple.com/videos/play/wwdc2020/10652/
                isPhotoPickerPresented.toggle()
            }.sheet(isPresented: $isPhotoPickerPresented) {
                PhotoPicker(isPhotoPickerPresented: $isPhotoPickerPresented, data: $inputData, presentImageAlert: $presentImageAlert)
            }.onChange(of: inputData) { _ in
                presentImageAlert = false
                guard let inputData = inputData else { return }
                guard let imageParsed = UIImage(data: inputData) else { return }
                image = Image(uiImage: imageParsed)
            }.alert(isPresented: $presentImageAlert) {
                Alert(
                    title: Text("Error Imagen"),
                    message: Text(messageImageAlert),
                    dismissButton: .default(Text("Ok"), action: {
                        presentImageAlert.toggle()
                    })
                )
            }.padding()
            
            // Image View - Contenedor de la imágen seleccionada
            image.resizable()
                .scaledToFill()
                .frame(width: 107, height: 107)
                .padding()
            
            Button("Seleccionar Documentos") {
                isFilePickerPresented.toggle()
            }.sheet(isPresented: $isFilePickerPresented) {
                DocumentPicker(isFilePickerPresented: $isFilePickerPresented, documentData: $documentData, presentDocumentAlert: $presentDocumentAlert)
            }.onChange(of: documentData) { _ in
                let bcf = ByteCountFormatter()
                bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                bcf.countStyle = .file
                self.documentSize = bcf.string(fromByteCount: Int64(documentData!.count))
            }.alert(isPresented: $presentDocumentAlert) {
                Alert(
                    title: Text("Error Documento"),
                    message: Text(messageDocumentAlert),
                    dismissButton: .default(Text("Ok"), action: {
                        presentDocumentAlert.toggle()
                    })
                )
            }.padding()
            
            Text("Data: " + (self.documentSize ?? "0 MB"))
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

