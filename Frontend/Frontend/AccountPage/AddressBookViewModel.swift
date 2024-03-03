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
                print("No documents")
                return
            }
            
            self.addresses = documents.map { queryDocumentSnapshot -> Address in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let address = data["address"] as? String ?? ""
                return Address(id: queryDocumentSnapshot.documentID, name: name, address: address)
            }
        }
    }
    
    func deleteAddress(at offsets: IndexSet) {
        // Iterate over the offsets to find the documents to delete
        offsets.forEach { index in
            // Get the ID of the document to delete
            let documentId = addresses[index].id
            
            // Delete the document from the 'addresses' collection
            db.collection("places").document(documentId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    // After confirming deletion from Firestore, remove the item from the local array
                    DispatchQueue.main.async {
                        self.addresses.remove(atOffsets: offsets)
                    }
                }
            }
        }
    }
}

