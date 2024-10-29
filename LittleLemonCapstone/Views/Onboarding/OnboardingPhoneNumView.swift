//
//  OnboardingPhoneNumView.swift
//  LittleLemonCapstone
//
//  Created by Mahreen Azam on 10/26/24.
//

import SwiftUI

struct OnboardingPhoneNumView: View {
    @EnvironmentObject var router: NavigationPathWrapper
    @State var phoneNumber = ""
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            // Sets the background color of the view
            appGreen.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Tell Us Your Phone Number:")
                    .foregroundColor(appYellow)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                TextField("Phone Number", text: $phoneNumber)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(.darkGray), lineWidth: 2)
                    }
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if !phoneNumber.isEmpty {
                            UserDefaults.standard.set(phoneNumber, forKey: phoneNumberKey)
                            UserDefaults.standard.set(true, forKey: loggedInKey)
                            router.navigate(to: .menuPage)
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
        .onAppear {
            phoneNumber = UserDefaults.standard.string(forKey: phoneNumberKey) ?? ""
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    router.navigateBack()
                }, label: {
                    Image(systemName: "arrow.backward")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                })
            }
        }
    }
}
