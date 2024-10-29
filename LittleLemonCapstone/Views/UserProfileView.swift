//
//  UserProfileView.swift
//  CourseraCapstone
//
//  Created by Mahreen Azam on 9/25/24.
//

import SwiftUI

struct UserProfileView: View {
    @EnvironmentObject var router: NavigationPathWrapper
    var controller: PersistenceController
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var phoneNumber = ""
    @State var showAlert: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text("Personal Information")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .padding(.bottom, 12)
            
            Text("Avatar")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Color(.darkGray))
                .padding(.bottom, 8)
            HStack {
                Spacer()
                Image(systemName: "brain.head.profile")
                    .font(.system(size: 60))
                    .padding(.bottom, 12)
                Spacer()
            }
            
            // Profile Info
            ProfileInfoView(firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber)
            
            Spacer()
            
            // Save and Log Out Buttons
            ProfileButtonView(controller: controller, firstName: $firstName, lastName: $lastName, email: $email, phoneNumber: $phoneNumber, showAlert: $showAlert).environmentObject(router)
        }
        .padding()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                MenuNavBarView()
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.navigateBack()
                }, label: {
                    Image(systemName: "arrow.backward.circle.fill")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(appGreen)
                })
            }
        }
        .alert("Changes Saved", isPresented: $showAlert, actions: {})
        .onAppear {
            firstName = UserDefaults.standard.string(forKey: firstNameKey) ?? ""
            lastName = UserDefaults.standard.string(forKey: lastNameKey) ?? ""
            email = UserDefaults.standard.string(forKey: emailKey) ?? ""
            phoneNumber = UserDefaults.standard.string(forKey: phoneNumberKey) ?? ""
        }
    }
}

// MARK: SubViews

struct ProfileInfoView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var phoneNumber: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("First Name")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Color(.darkGray))
            TextField("First Name", text: $firstName)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(.darkGray), lineWidth: 2)
                }
                .padding(.bottom, 8)
            
            Text("Last Name")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Color(.darkGray))
            TextField("Last Name", text: $lastName)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(.darkGray), lineWidth: 2)
                }
                .padding(.bottom, 8)
            
            Text("Email")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Color(.darkGray))
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(.darkGray), lineWidth: 2)
                }
                .padding(.bottom, 8)

            Text("Phone Number")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .foregroundColor(Color(.darkGray))
            TextField("Phone Number", text: $phoneNumber)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(.darkGray), lineWidth: 2)
                }
                .padding(.bottom, 8)
        }
    }
}

struct ProfileButtonView: View {
    @EnvironmentObject var router: NavigationPathWrapper
    var controller: PersistenceController
    @Binding var firstName: String
    @Binding var lastName: String
    @Binding var email: String
    @Binding var phoneNumber: String
    @Binding var showAlert: Bool

    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Button(action: {
                    UserDefaults.standard.set(firstName, forKey: firstNameKey)
                    UserDefaults.standard.set(lastName, forKey: lastNameKey)
                    UserDefaults.standard.set(email, forKey: emailKey)
                    UserDefaults.standard.set(phoneNumber, forKey: phoneNumberKey)
                    
                    showAlert = true
                }, label: {
                    Text("Save Changes")
                })
                .padding()
                .frame(width: 250)
                .foregroundColor(.white)
                .fontWeight(.bold)
                .background(appGreen)
                .cornerRadius(12)
                
                Button(action: {
                    if let domain = Bundle.main.bundleIdentifier {
                        // Removes all values in UserDefaults
                        UserDefaults.standard.removePersistentDomain(forName: domain)
                        controller.clear()
                        router.logout()
                    }
                }, label: {
                    Text("Log Out")
                })
                .padding()
                .frame(width: 250)
                .foregroundColor(.black)
                .background(appYellow)
                .fontWeight(.bold)
                .cornerRadius(12)
            }
            
            Spacer()
        }
    }
}

