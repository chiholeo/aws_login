//
//  authService.swift
//  aws_login
//
//  Created by wmc560 on 7/11/2022.
//

import Foundation
import Amplify
import AWSCognitoAuthPlugin
import UIKit
import Foundation
import Combine

class AuthService: ObservableObject {
   // @Published var isSignedIn = false
    @Published var givenName: String = ""
    @Published var userEmail: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    @Published var familyName: String = ""
    
    func checkStatus() {
        _ = Amplify.Auth.fetchAuthSession { [weak self] result in
            switch result {
            case .success(let session):
                //print("User session - \(session)")
                print("User session")
                DispatchQueue.main.async {
                    self?.isLoggedIn = session.isSignedIn
                    
                    self?.fetchAttributes()
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    func fetchAttributes() {
        Amplify.Auth.fetchUserAttributes() { result in
            switch result {
            case .success(let attributes):
                //print("User attributes - \(attributes)")
                
                for item in attributes
                {
                    if let Gatt = item as? AuthUserAttribute{
                        //print("attr: - \(Gatt.key) - \(Gatt.value)")
                        if Gatt.key == AuthUserAttributeKey.email{
                            print ("email: - \(Gatt.value)")
                        }
                        if Gatt.key == AuthUserAttributeKey.picture{
                            print ("picture: - \(Gatt.value)")
                        }
                        if Gatt.key == AuthUserAttributeKey.name{
                            print ("name: - \(Gatt.value)")
                        }                       }
                }
                
                //print("User attributes")
                //let email = attributes.filter({ $0.key.rawValue == "sub" }).first?.value
                //print("email - \(email)")
            case .failure(let error):
                print("Fetching user attributes failed with error \(error)")
            }
        }
    }
    
    private var window: UIWindow {
        guard
            let scene = UIApplication.shared.connectedScenes.first,
            let windowSceneDelegate = scene.delegate as? UIWindowSceneDelegate,
            let window = windowSceneDelegate.window as? UIWindow
        else { return UIWindow() }
        
        return window
    }
    func socialSignInWithWebUI() -> AnyCancellable {
        
        Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: window)            .resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Sign in failed \(authError)")
                }
            }
            receiveValue: { _ in
                print("Sign in succeeded")
            }
    }
    func webSignIn() {
        let pluginOptions = AWSAuthWebUISignInOptions(preferPrivateSession: false)
        let options = AuthWebUISignInRequest.Options(pluginOptions: pluginOptions)
        _ = Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: window, options: options)
            { result in
            switch result {
            case .success:
                print("Signed in")
               // self.fetchAttributes()
                self.checkStatus()
            case .failure(let error):
                print(error)
            }
        }
    }
    func webSignIntest() {
        _ = Amplify.Auth.signInWithWebUI(for: .google, presentationAnchor: window) { result in
            switch result {
            case .success:
                print("Signed in")
               // self.fetchAttributes()
                self.checkStatus()
            case .failure(let error):
                print(error)
            }
        }
    }
    func signOut() {
        _ = Amplify.Auth.signOut { result in
            switch result {
            case .success:
                print("Signed out")
                self.clearLocal()
                self.checkStatus()
            case .failure(let error):
                print(error)
            }
        }
    }
    func clearLocal(){
        Amplify.DataStore.clear { result in
            switch result {
            case .success:
                print("DataStore cleared")
            case .failure(let error):
                print("Error clearing DataStore: \(error)")
            }
        }
    }
    func fetchCurrentAuthSession() -> AnyCancellable {
        Amplify.Auth.fetchAuthSession().resultPublisher
            .sink {
                if case let .failure(authError) = $0 {
                    print("Fetch session failed with error \(authError)")
                }
            }
            receiveValue: { session in
                print("Is user signed in - \(session.isSignedIn)")
            }
    }
    
    func observeAuthEvents() {
        _ = Amplify.Hub.listen(to: .auth) { [weak self] result in
            switch result.eventName {
            case HubPayload.EventName.Auth.signedIn:
                DispatchQueue.main.async {
                    self?.isLoggedIn = true
                }
                
            case HubPayload.EventName.Auth.signedOut,
                 HubPayload.EventName.Auth.sessionExpired:
                DispatchQueue.main.async {
                    self?.isLoggedIn = false
                }
                
            default:
                break
            }
        }
    }
}
