//
//  OnboardingEmailView.swift
//  CourseraCapstone
//
//  Created by Mahreen Azam on 10/26/24.
//

import SwiftUI

struct OnboardingEmailView: View {
    @EnvironmentObject var router: NavigationPathWrapper
    @State var email = ""
    @State var showAlert = false
    
    var body: some View {
        ZStack {
            // Sets the background color of the view
            appGreen.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                Text("Tell Us Your Email:")
                    .foregroundColor(appYellow)
                    .font(.system(size: 24, weight: .heavy, design: .rounded))
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color(.darkGray), lineWidth: 2)
                    }
                
                HStack {
                    Spacer()

                    Button(action: {
                        if !email.isEmpty {
                            UserDefaults.standard.set(email, forKey: emailKey)
                            router.navigate(to: .onboardingPhoneNumPage)
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
            email = UserDefaults.standard.string(forKey: emailKey) ?? ""
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
