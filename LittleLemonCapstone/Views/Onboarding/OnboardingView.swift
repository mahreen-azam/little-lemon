//
//  OnboardingView.swift
//  LittleLemonCapstone
//
//  Created by Mahreen Azam on 9/25/24.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var router = NavigationPathWrapper()
    var persistence = PersistenceController.shared
    
    var body: some View {
        NavigationStack(path: $router.path) {
            // First View is OnboardingNameView
            // We send the navigation stack all possible navigation destinations here the Router
            OnboardingNameView()
                .navigationDestination(for: NavigationPathWrapper.Destination.self) { destination in
                    switch destination {
                    case .onboardingNamePage:
                        OnboardingNameView()
                    case .onboardingEmailPage:
                        OnboardingEmailView()
                    case .onboardingPhoneNumPage:
                        OnboardingPhoneNumView()
                    case .menuPage:
                        MenuView(controller: persistence)
                            .environment(\.managedObjectContext, persistence.container.viewContext)
                    case .userProfilePage:
                        UserProfileView(controller: persistence)
                    }
                }
        }
        .environmentObject(router)
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
