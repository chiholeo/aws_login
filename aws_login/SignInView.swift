//
//  SignInView.swift
//  todo2
//
//  Created by wmc560 on 3/10/2022.
//

import SwiftUI
import Amplify

struct SignInView: View {
    //@EnvironmentObject var auth: GAuthService
    @EnvironmentObject var auth: AuthService
    var body: some View {
        //Button("Sign In", action: auth.webSignIn)
        VStack{

            Button("Sign In", action: auth.webSignIntest)
                .padding()
                .background(Color.purple)
                .foregroundColor(.white)
                .cornerRadius(3)
            Button("check auth status", action: auth.checkStatus)
            Button("add post", action: addPost)
            Spacer()
            Button("read post", action: checkRecord)
            Spacer()
            Button("add Private post", action: pAddPost)
            Spacer()
            Button("read Private post", action: pCheckRecord)
            
        }
    }
    func addPost() {
        //   checkRecord()
        let post = LoginPost(title: "Before signin Create an Amplify DataStore app",
                        status: .active)
        do {
            try  Amplify.DataStore.save(post)
            print("Post saved successfully!")
        } catch let error as DataStoreError {
            print("Error saving post \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }

    func checkRecord() {
        Amplify.DataStore.query(LoginPost.self) { result in
            switch result {
            case .success(let posts):
                for post in posts{
                    print("Post title \(post.title)")
                }
                print("Posts retrieved successfully: \(posts.count)")
            case .failure(let error):
                print("Error retrieving posts \(error)")
            }
        }
    }
    func pAddPost() {
        //   checkRecord()
        let post = PLoginPost(title: "private after login Create an Amplify DataStore app",
                        status: .active)
        do {
            try  Amplify.DataStore.save(post)
            print("Post saved successfully!")
        } catch let error as DataStoreError {
            print("Error saving post \(error)")
        } catch {
            print("Unexpected error \(error)")
        }
    }
    func pCheckRecord() {
        Amplify.DataStore.query(PLoginPost.self) { result in
            switch result {
            case .success(let posts):
                for post in posts{
                    print("Post title \(post.title)")
                }
                print("Posts retrieved successfully: \(posts.count)")
            case .failure(let error):
                print("Error retrieving posts \(error)")
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
