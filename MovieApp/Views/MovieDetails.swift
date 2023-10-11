//
//  MovieDetails.swift
//  MovieApp
//
//  Created by Rana Ayman on 09/10/2023.
//

import Foundation
import SwiftUI
struct MovieDetailsView: View {
    @Binding var text: String
    @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        VStack{
            TextField("Enter text", text: $text)
            Button("back to home"){
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
