//
//  GoogleAuthentication.swift
//  Frontend
//
//  Created by nhi vu on 2/20/24.
//
import Foundation
import Firebase
import GoogleSignIn

struct GoogleAuthentication {
    func googleOauth() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No Firebase clientID found")
        }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Get rootView
        let scene = await UIApplication.shared.connectedScenes.first as? UIWindowScene
        guard let rootViewController = await scene?.windows.first?.rootViewController else {
            fatalError("There is no root view controller!")
        }

        // Google sign in authentication response
        let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = result.user
        
        guard let idToken = user.idToken?.tokenString else {
            fatalError("Unexpected error occurred, please retry")
        }

        // Firebase auth
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
        let authResult = try await Auth.auth().signIn(with: credential)
        
        // userID is non-optional, so we can directly use it
        let userID = authResult.user.uid
        await createUserProfile(userID: userID)
    }

    func logout() async throws {
        GIDSignIn.sharedInstance.signOut()
        try Auth.auth().signOut()
    }

    func createUserProfile(userID: String) async {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        do {
            try await withCheckedThrowingContinuation({ continuation in
                userRef.setData([
                    "createdAt": FieldValue.serverTimestamp(),
                    "updatedAt": FieldValue.serverTimestamp(),
                    // Add any other initial data needed for the user
                ], merge: true) { error in
                    if let error = error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: ())
                    }
                }
            } as (CheckedContinuation<Void, Error>) -> Void)  // Type annotation for Void return type
            print("User profile successfully created or updated!")
        } catch {
            print("Error writing user profile: \(error)")
        }
    }
}

extension String: Error {}

