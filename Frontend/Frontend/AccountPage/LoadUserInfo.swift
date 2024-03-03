//
//  LoadUserInfo.swift
//  Frontend
//
//  Created by nhi vu on 2/21/24.
//

import Foundation
import GoogleSignIn

struct LoadUserInfo {
    static func loadGoogleUser() -> GIDGoogleUser? {
        // Check if the Google user is logged in and return the user object
        return GIDSignIn.sharedInstance.currentUser
    }
}
