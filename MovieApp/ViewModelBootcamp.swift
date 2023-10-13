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
    
    init() {
        getFruits()
    }
    
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
    // @ObservedObject  makes the view reloads , rerenders
    //   @ObservedObject  var fruitViewModel : FruitViewModel  = FruitViewModel()
    
    //  @StateObject makes fruitViewModel presist (without recreating it)
    // USE IT N CREATION / INIT -> first time creating this object
    @StateObject  var fruitViewModel : FruitViewModel  = FruitViewModel()
    // is subViews -> passing it -> USE @ObservedObject
    
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
                }
            }.listStyle(GroupedListStyle())
                .navigationTitle("Fruit List")
                .navigationBarItems(trailing:
                                        NavigationLink(destination: SecondScreen(fruitViewModel:fruitViewModel), label: {
                    Image(systemName: "arrow.right").font(.title)

                }))
            // it will be called everytime the screen appears
//                .onAppear{
//                    // call function to get list of fruits then append it to fruitArray
//                    fruitViewModel.getFruits()
//                }
        }
    }
}
   
    



struct SecondScreen: View {
    
    @Environment(\.presentationMode) var presentaionMode
    @ObservedObject var fruitViewModel : FruitViewModel
    
    
    var body: some View {
        ZStack{
            Color.green.ignoresSafeArea()
            VStack{
                ForEach(fruitViewModel.fruitArray) { fruit in
                    Text(fruit.name).foregroundColor(.white).font(.headline)
                }
            }
//            Button {
//                presentaionMode.wrappedValue.dismiss()
//            } label: {
//                Text("GO BACK").foregroundColor(.white).font(.largeTitle).fontWeight(.semibold)
//            }

        }
    }
}


struct ViewModel_Previews: PreviewProvider {
    static var previews: some View {
        ViewModel().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//        SecondScreen()
    }
}
