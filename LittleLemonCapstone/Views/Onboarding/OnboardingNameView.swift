//
//  OnboardingNameView.swift
//  LittleLemonCapstone
//
//  Created by Mahreen Azam on 10/25/24.
//

import SwiftUI

struct OnboardingNameView: View {
    @EnvironmentObject var router: NavigationPathWrapper
    @State var firstName = ""
    @State var lastName = ""
    @State var showAlert = false

    var body: some View {
        ZStack {
            // Sets the background color of the view
            appGreen.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Tell Us Your First Name:")
                    .foregroundColor(appYellow)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                TextField("First Name", text: $firstName)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(.darkGray), lineWidth: 2)
                    }
                
                Text("Tell Us Your Last Name:")
                    .foregroundColor(appYellow)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                TextField("Last Name", text: $lastName)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(.darkGray), lineWidth: 2)
                    }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if !firstName.isEmpty, !lastName.isEmpty {
                            UserDefaults.standard.set(firstName, forKey: firstNameKey)
                            UserDefaults.standard.set(lastName, forKey: lastNameKey)
                            router.navigate(to: .onboardingEmailPage)
                        } else {
                            showAlert = true
                        }
                    }, label: {
                        Text("Next")
                    })
                    .padding()
                    .frame(width: 100)
                    .background(appYellow)
                    .foregroundColor(appGreen)
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    Spacer()
                }
                .padding(.top, 50)
            }
            .padding()
        }
        .alert("Registration Error", isPresented: $showAlert, actions: {}, message: {
            Text("All fields must be filled out to continue.")
        })
        .navigationBarBackButtonHidden()
        .onAppear {
            firstName = UserDefaults.standard.string(forKey: firstNameKey) ?? ""
            lastName = UserDefaults.standard.string(forKey: lastNameKey) ?? ""
        
            // Navigates to MenuView immediately if user is already registered
            if ((UserDefaults.standard.object(forKey: loggedInKey) ?? false) as! Bool == true) {
                router.navigate(to: .menuPage)
            }
        }
    }
}
