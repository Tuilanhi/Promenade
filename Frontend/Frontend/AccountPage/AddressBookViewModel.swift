//
//  AddressBookViewModel.swift
//  Frontend
//
//  Created by nhi vu on 3/1/24.
//

import Foundation
import Firebase


// Define your address model
struct Address: Identifiable {
    var id: String  // Assuming each address has a unique ID
    var name: String
    var address: String
}

// ViewModel to fetch addresses from Firestore
class AddressBookViewModel: ObservableObject {
    @Published var addresses = [Address]()
    private var db = Firestore.firestore()
    
    // Add a userId property to get the current user's ID from Firebase
    private var userId: String? {
        Auth.auth().currentUser?.uid
    }
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        guard let userId = userId else {
            print("Error: User is not authenticated.")
            return
        }
        
        db.collection("users").document(userId).collection("places")
            .addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents or error: \(String(describing: error))")
                return
            }
            print("Snapshot listener triggered with \(documents.count) documents.")
            DispatchQueue.main.async {
                self.addresses = documents.map { queryDocumentSnapshot -> Address in
                    let data = queryDocumentSnapshot.data()
                    let name = data["name"] as? String ?? ""
                    let address = data["address"] as? String ?? ""
                    return Address(id: queryDocumentSnapshot.documentID, name: name, address: address)
                }
            }
        }
    }
    
    func deleteAddressById(_ documentId: String, completion: @escaping () -> Void) {
        guard let userId = userId else {
            print("Error: User is not authenticated.")
            return
        }
        
        db.collection("users").document(userId).collection("places").document(documentId)
            .delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
                DispatchQueue.main.async {
                    completion()
                }
            }
        }
    }
    
    func savePlace(name: String, address: String, id: String? = nil) {
        guard let userId = userId else {
           print("Error: User is not authenticated.")
           return
        }
        
        let db = Firestore.firestore()
        
        let placeData: [String: Any] = [
            "name": name,
            "address": address
        ]
        
        if let id = id {
            // Update existing document
            db.collection("users").document(userId).collection("places").document(id)
                .setData(placeData) { error in
                if let error = error {
                    print("Error updating place: \(error.localizedDescription)")
                } else {
                    print("Place updated successfully")
                }
            }
        } else {
            // Add a new document
            db.collection("users").document(userId).collection("places")
                .addDocument(data: placeData) { error in
                if let error = error {
                    print("Error saving place: \(error.localizedDescription)")
                } else {
                    print("Place saved successfully")
                }
            }
        }
    }
}

