//
//  ContentView.swift
//  MovieApp
//
//  Created by Rana Ayman on 04/10/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    let networkService = NetworkService()
    @State var res = [User]()
    @State private var path = [String]()
    
    
    var body: some View {
        NavigationStack(path: $path){
            List{
                NavigationLink("second page", value:"ABC" )
                Button("navigate to xyz"){
                    path.append("xyz")
                }.navigationDestination(for: String.self) { string in
                    VStack{
                        Text(string)
                        Button("pop to root"){
                            // it will remove all strings from path array 
                            path.removeAll()
                            
                        }
                    }
                }
            }
        }
        
    }
        //   NavigationStack {
//            NavigationLink(destination: MovieDetailsView()) {
//                List(res, id: \.id) { user in
//                    Text(user.name)
//                }
//                .onAppear {
//                    networkService.fetchData { users, error in
//                      if let error = error {
//                          print("Error: \(error)")
//                          return
//                      }
//
//                      if let users = users {
//                          print("Users: \(users)")
//                          res = users
//                      }
//                  }
//
//                }
//            }
 //           .navigationTitle("Home Page")

        
    
    
    func getMovies(){
        networkService.getMoviesList(from: "/movies.json") { result in
            switch result {
            case .success(let data):
                // Handle successful response and data parsing here
                print("Received data:", data)
            case .failure(let error):
                // Handle the error here
                print("Error:", error)
            }
        }
    }
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
