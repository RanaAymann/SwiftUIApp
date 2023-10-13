//
//  ViewModel.swift
//  MovieApp
//
//  Created by Rana Ayman on 13/10/2023.
//

import Foundation
import SwiftUI



struct FruitModel : Identifiable {
    let id : String = UUID().uuidString
    let name: String
    let count : Int
}


// to separate the data from the UI
// for all the data behind the scences

class FruitViewModel : ObservableObject {
    
// @Published  is the same as @State ,but within a class
    // publish -> new changes
  @Published  var fruitArray : [FruitModel] = []
  @Published var isLoading: Bool = false
    
    func getFruits(){
        let fruit1 = FruitModel(name: "Banana", count: 7)
        let fruit2 = FruitModel(name: "Grape", count: 20)
        let fruit3 = FruitModel(name: "Orange", count: 1)
        
        isLoading = true
        
        // load for 3 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
            self.fruitArray.append(fruit1)
            self.fruitArray.append(fruit2)
            self.fruitArray.append(fruit3)
            self.isLoading = false
            
        }
    
    }
    
        func deleteFruit (index: IndexSet){
            fruitArray.remove(atOffsets: index)
        
    }
}



struct ViewModel: View {
    
//    @State var fruitArray : [FruitModel] = [
//    FruitModel(name: "Apple", count: 2)]
    
    // this should have property that tells the view that it might be changing
    // @ObservedObject used for whole object ( class )
    // @State is used for variables only
 @ObservedObject  var fruitViewModel : FruitViewModel  = FruitViewModel()
    
    var body: some View {
        NavigationView{
            List {
                if fruitViewModel.isLoading {
                    ProgressView()
                } else {
                    ForEach(fruitViewModel.fruitArray) { fruit in
                        HStack{
                            Text("\(fruit.count)").foregroundColor(.red)
                            Text(fruit.name).font(.headline).bold()
                            
                        }
                        // swipe to delete in forEach
                    }.onDelete(perform: fruitViewModel.deleteFruit)
                        .listStyle(GroupedListStyle())
                }
            }.navigationTitle("Fruit List")
                .onAppear{
                    // call function to get list of fruits then append it to fruitArray
                    fruitViewModel.getFruits()
                }
        }
    }
    
}


struct ViewModel_Previews: PreviewProvider {
    static var previews: some View {
        ViewModel().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
