//
//  aws_loginApp.swift
//  aws_login
//
//  Created by wmc560 on 7/11/2022.
//
import SwiftUI
import Amplify
import AWSDataStorePlugin
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import Combine

@main
struct aws_loginApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    //use all amplify methon to login at google
    @ObservedObject var auth = AuthService()
    //use google own sign in and get user pool by awsmobileclient
    //@ObservedObject var auth = GAuthService()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ApplicationSwitcher()
            }
            .navigationViewStyle(.stack)
            .environmentObject(auth)
        }
    }
    // add a default initializer and configure Amplify
    init() {
        configureAmplify()
        
    }
    
    func configureAmplify() {
        //Amplify.Logging.logLevel = .debug
        let models = AmplifyModels()
        let apiPlugin = AWSAPIPlugin(modelRegistration: models)
        //let dataStorePlugin = AWSDataStorePlugin(modelRegistration: models)
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.add(plugin: apiPlugin)
          //  try Amplify.add(plugin: AWSAPIPlugin())
            //try Amplify.add(plugin: dataStorePlugin)
            try Amplify.add(
                            plugin: AWSDataStorePlugin(
                                modelRegistration: models,
                                configuration: .custom(authModeStrategy: .multiAuth)
                            )
                            )
            try Amplify.configure()
            
            print("Amplify configured with auth plugin")
            
            Amplify.DataStore.clear { result in
                switch result {
                case .success:
                    print("DataStore cleared")
                case .failure(let error):
                    print("Error clearing DataStore: \(error)")
                }
            }
            auth.checkStatus()
            
        } catch {
            print("Failed to initialize Amplify with \(error)")
        }
        //auth.checkSessionStatus()
        //test data store
       /*
        let post = Post(title: "20221104 10:07 My post with comments",
                        rating: 5,
                        status: .active)
        let editor = User(username: "Nadia")

        let sink = Amplify.DataStore.save(post)
            .flatMap { _ in Amplify.DataStore.save(editor) }
            .flatMap { _ in Amplify.DataStore.save(PostEditor(post: post, user: editor)) }
            .sink {
                if case let .failure(error) = $0 {
                    print("Error saving post, user and postEditor: \(error.localizedDescription)")
                }
            }
            receiveValue: { _ in
                print("Saved user, post and postEditor!")
            }
         
        let hubEventSubscriber = Amplify.Hub.publisher(for: .dataStore).sink { event in
            if event.eventName == HubPayload.EventName.DataStore.networkStatus {
                guard let networkStatus = event.data as? NetworkStatusEvent else {
                    print("Failed to cast data as NetworkStatusEvent")
                    return
                }
                print("User receives a network connection status: \(networkStatus.active)")
            }
        }
        Amplify.DataStore.start { result in
            switch result {
            case .success:
                print("DataStore started")
            case .failure(let error):
                print("Error starting DataStore: \(error)")
            }
        }
        */
        //auth.checkStatus()

    }
    
}

struct ApplicationSwitcher: View {
    //@EnvironmentObject var auth: GAuthService
    @EnvironmentObject var auth: AuthService
    var body: some View {
        if auth.isLoggedIn {
            SessionView()
         //   .environmentObject(auth)
        } else {
            SignInView()
        //    .environmentObject(auth)
        }
    
    }
}
