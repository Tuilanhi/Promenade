//
//  AddressBookViewModel.swift
//  Frontend
//
//  Created by nhi vu on 3/1/24.
//

import Foundation
import FirebaseFirestore

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
    
    init() {
        fetchData()
    }
    
    func fetchData() {
        db.collection("places").addSnapshotListener { (querySnapshot, error) in
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
        db.collection("places").document(documentId).delete() { err in
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
        let db = Firestore.firestore()
        
        let placeData: [String: Any] = [
            "name": name,
            "address": address
        ]
        
        if let id = id {
            // Update existing document
            db.collection("places").document(id).setData(placeData) { error in
                if let error = error {
                    print("Error updating place: \(error.localizedDescription)")
                } else {
                    print("Place updated successfully")
                }
            }
        } else {
            // Add a new document
            db.collection("places").addDocument(data: placeData) { error in
                if let error = error {
                    print("Error saving place: \(error.localizedDescription)")
                } else {
                    print("Place saved successfully")
                }
            }
        }
    }
}

