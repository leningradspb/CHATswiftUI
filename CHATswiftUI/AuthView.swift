//
//  ContentView.swift
//  CHATswiftUI
//
//  Created by Eduard Sinyakov on 26.10.2021.
//

import SwiftUI
import Firebase

struct AuthView: View {
     
    @State var isLogInMode = false
    @State var email = ""
    @State var password = ""
    @State var authStatusMessage = ""
    
    private let logInConst = "Log In"
    private let createAccountConst = "Create Account"
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    /// сегмент с выбором аутентификации
                    Picker(selection: $isLogInMode) {
                        Text(logInConst)
                            .tag(true)
                        Text(createAccountConst)
                            .tag(false)
                    } label: {
                        Text("Picker")
                    }.pickerStyle(.segmented)
                    
                    if !isLogInMode {
                        /// иконка профиля
                        Button {
                            print("Profile")
                        } label: {
                            Image(systemName: "person.fill").font(.system(size: 64))
                        }.padding()
                    }
                    
                    Group {
                        TextField("Email", text: $email).keyboardType(.emailAddress).autocapitalization(.none)
                        SecureField("Password", text: $password)
                    }.padding(12).background(Color.white)
                    
                   
                    
                    /// кнопка войти или создать аккаунт
                    Button {
                        handleAuth()
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLogInMode ? logInConst : createAccountConst).foregroundColor(.white).padding(.vertical, 10).font(.system(size: 14, weight: .bold, design: .default))
                            Spacer()
                        }.background(Color.blue)
                    }
                    
                    Text(authStatusMessage).foregroundColor(.red)
                }.padding()
            }
            .navigationTitle(isLogInMode ? logInConst : createAccountConst)
            .background(Color.init(white: 0, opacity: 0.05).ignoresSafeArea())
        }.navigationViewStyle(.stack) // чтобы убрать принты с ошибками по констрейнтам
    }
    
    private func handleAuth() {
        if isLogInMode {
            print("Try to log in")
            logInUser()
        } else {
            print("Lets create account")
            createNewAccount()
        }
    }
    
    private func logInUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let err = error {
                print("Failed to log in user:", err)
                authStatusMessage = "Failed to log in user: \(err.localizedDescription)"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "nil uid")")
            if let user = result?.user {
                authStatusMessage = "Successfully logged in as user: \(user.uid)"
            } else {
                print("Failed to get logIn result without error")
                authStatusMessage = "Failed to get logIn result without error"
            }
        }
    }
    
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let err = error {
                print("Failed to crate user:", err)
                authStatusMessage = "Failed to crate user: \(err.localizedDescription)"
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "nil uid")")
            if let user = result?.user {
                authStatusMessage = "Successfully created user: \(user.uid)"
            } else {
                print("Failed to get result without error")
                authStatusMessage = "Failed to get result without error"
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}

final class FirebaseManager {
    let auth: Auth
    
    static let shared = FirebaseManager()
    
    init() {
        FirebaseApp.configure()
        auth = Auth.auth()
    }
}
