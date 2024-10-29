//
//  NavigationPathHandler.swift
//  LittleLemonCapstone
//
//  Created by Mahreen Azam on 10/29/24.
//

import Foundation
import SwiftUI

class NavigationPathWrapper: ObservableObject {
    // All destinations within app 
    enum Destination: Codable, Hashable {
        case onboardingNamePage
        case onboardingEmailPage
        case onboardingPhoneNumPage
        case menuPage
        case userProfilePage
    }
    
    @Published var path = NavigationPath()
    
    // MARK: Navigation Functions
    
    func navigate(to destination: Destination) {
        path.append(destination)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        // Root could be Menu screen or Onboarding Screen depending on how app started
        path.removeLast(path.count)
    }
    
    func logout() {
        // Resets navigation path, user is navigated to Onboarding
        path = NavigationPath()
        navigate(to: .onboardingNamePage)
    }
}
