//
//  Router.swift
//  MovieApp
//
//  Created by Rana Ayman on 09/10/2023.
//

import Foundation
import SwiftUI


class Router : ObservableObject {
    
    @Published  var mainStack: [NavigationType] = []
   
    func popLast(){
        if(mainStack.contains(.moviesHome) && mainStack.count == 1){
            return
        }
        mainStack.popLast()
    }
    func append(_ val : NavigationType){
        print(val)
        print(mainStack)
        mainStack.append(val)
    }
    
    
    func logout(){
        UserDefaults.standard.set(false, forKey: "isLoggedin")
        mainStack.removeAll()
        mainStack.append(.moviesHome)
    }
}

enum NavigationType : String , Hashable {
    case moviesHome = "moviesHome"
    case movieDetails = "movieDetails"

}
