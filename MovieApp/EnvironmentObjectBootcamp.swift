//
//  EnvironmentObjectBootcamp.swift
//  SwiftUIApp
//
//  Created by Rana Ayman on 15/10/2023.
//

import Foundation
import SwiftUI

// EnvironmentObject -> can be accessed without passing it to views

// EnviromentViewModel can be HomePageViewModel that contains all functions, fetching from db

class EnviromentViewModel : ObservableObject {
    
    @Published var dataArray : [String] = []
    
    
    init() {
        getData()
    }
    
    func getData(){
//        self.dataArray.append("iPhone")
//        self.dataArray.append("iPad")
        self.dataArray.append(contentsOf: ["iPhone","iPad","iMac", "Apple Watch"])


    }
}

struct EnvironmentObjectBootcamp: View {
    
    // initialize viewModel -> init func will be called by default
    @StateObject var viewModel : EnviromentViewModel = EnviromentViewModel()
    
    var body : some View{
        NavigationView {
            List {
                // ForEach with ids bc array items doesn't have Id
                ForEach(viewModel.dataArray, id: \.self) { item in
                    NavigationLink(destination: DetailView(selectedItem: item), label: {
                        Text(item)

                    })
                }
            }.navigationTitle("iOS Devices")
            // make viewModel accessed from all navigation views
        }.environmentObject(viewModel)
        
    }
}

struct DetailView : View {
    let selectedItem : String
    
//    @ObservedObject var viewModel : EnviromentViewModel
    
    var body: some View {
        ZStack {
           // background
            Color.orange.ignoresSafeArea()
            
            // foregroung
            NavigationLink(destination: FinalView()) {
                Text(selectedItem).font(.headline).foregroundColor(.orange).padding().padding(.horizontal).background(Color.white).cornerRadius(30)
            }
        }
    }
}

struct FinalView : View {
    
//    @ObservedObject var viewModel : EnviromentViewModel
    
   @EnvironmentObject var viewModel : EnviromentViewModel

    var body: some View {
        ZStack {
            // background
            LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
                // foreground
            ScrollView {
                VStack(spacing: 20){
                    ForEach(viewModel.dataArray, id: \.self) { item in
                        Text(item)
                    }
                }
                .foregroundColor(.white)
                    .font(.largeTitle)
            }
        }
    }
}
struct EnvironmentObjectBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        EnvironmentObjectBootcamp().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//        DetailView(selectedItem: "iPhone").environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
