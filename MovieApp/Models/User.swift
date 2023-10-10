//
//  User.swift
//  MovieApp
//
//  Created by Rana Ayman on 08/10/2023.
//

import Foundation


struct User: Codable, Identifiable , Hashable {
    let id: Int
    let name: String
}
