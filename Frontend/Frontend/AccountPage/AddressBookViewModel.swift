//
//  AddressBookViewModel.swift
//  Frontend
//
//  Created by nhi vu on 2/29/24.
//
import Foundation

struct SavedAddress: Codable, Identifiable {
    let id: UUID
    let name: String
    let address: String
    
    init(name: String, address: String) {
        self.id = UUID()
        self.name = name
        self.address = address
    }
}

class AddressBookViewModel: ObservableObject {
    @Published var savedAddresses: [SavedAddress] {
        didSet {
            saveToPersistentStore()
        }
    }
    
    init() {
        self.savedAddresses = []
        self.savedAddresses = loadFromPersistentStore()
    }
    
    func saveNewAddress(name: String, address: String) {
        let newAddress = SavedAddress(name: name, address: address)
        savedAddresses.append(newAddress)
    }
    
    private func saveToPersistentStore() {
        if let encodedData = try? JSONEncoder().encode(savedAddresses) {
            UserDefaults.standard.set(encodedData, forKey: "SavedAddresses")
        }
    }
    
    private func loadFromPersistentStore() -> [SavedAddress] {
        if let data = UserDefaults.standard.data(forKey: "SavedAddresses"),
           let saved = try? JSONDecoder().decode([SavedAddress].self, from: data) {
            return saved
        }
        return []
    }
}

