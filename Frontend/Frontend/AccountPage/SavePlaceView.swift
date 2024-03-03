//
//  SavePlaceView.swift
//  Frontend
//
//  Created by nhi vu on 2/29/24.
//

import SwiftUI
import FirebaseFirestore

struct SavePlaceView: View {
    @Environment(\.presentationMode) var presentationMode
    var address: String
    @State private var placeName: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
                .padding(.leading)
                Spacer()
                Text("Save Place")
                    .font(.title)
                    .foregroundColor(.white)
                Spacer()
                // Add an invisible spacer here to align the X button and title center
                Spacer().frame(width: 40, height: 60)
            }
            .background(Color.black)
            .padding(.top, UIApplication
                .shared
                .connectedScenes
                .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }?.safeAreaInsets.top)
            .padding(.bottom, 10)
            
            HStack {
                Text("Name")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
            }
            .padding(.bottom, 5)
            TextField("e.g. Ryan's Home", text: $placeName)
                .padding(.leading, 16)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .overlay {
                    ClearButton(text: $placeName)
                        .padding(.trailing)
                }
                

            Divider()

            HStack {
                Text("Address")
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
            }
            .padding(.bottom, 5)
            Text(address)
                .padding(.leading, 16)
                .padding(.bottom, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()

            Spacer()

            Divider()
            

            Button(action: {
                // Handle saving to Firebase here
                savePlace()
            }) {
                Text("Save Place")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(height: 50)
                    .foregroundColor(.white)
                    .background(placeName.isEmpty ? Color.gray : Color.black)
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 15)
        }
        .edgesIgnoringSafeArea(.top) // Ignore the safe area to allow the color to extend to the top of the screen
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func savePlace() {
        // Ensure Firebase has been properly initialized
        let db = Firestore.firestore()
        
        // Create a dictionary representing the data you want to save
        let placeData: [String: Any] = [
            "name": placeName,
            "address": address
        ]
        
        // Add a new document with a generated ID to a collection "places"
        db.collection("places").addDocument(data: placeData) { error in
            if let error = error {
                // Handle any errors
                print("Error saving place: \(error.localizedDescription)")
            } else {
                // If the save was successful, print a message and dismiss the view
                print("Place saved successfully: \(self.placeName) at \(self.address)")
                self.presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

// Add a preview for your SavePlaceView
struct SavePlaceView_Previews: PreviewProvider {
    static var previews: some View {
        SavePlaceView(address: "Texas Avenue H-E-B")
    }
}

