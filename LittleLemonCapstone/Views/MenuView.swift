//
//  MenuView.swift
//  CourseraCapstone
//
//  Created by Mahreen Azam on 9/25/24.
//

import SwiftUI
import CoreData

// MARK: Main View:
struct MenuView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var router: NavigationPathWrapper
    var controller: PersistenceController
    
    @State var hasMenuData: Bool = false
    @State var searchText: String = ""
    
    var body: some View {
        VStack {
            // Hero
            HeroView(searchText: $searchText)
            
            // Order Menu
            OrderMenuView()
                .padding()
            
            Divider()
                .padding([.leading, .trailing])
            
            // Menu List
            VStack {
                FetchedObjects(predicate: buildPredicate(), sortDescriptors: buildSortDescriptors()) { (dishes: [Dish]) in
                    List {
                        ForEach(dishes, id: \.self) { item in
                            MenuListView(item: item)
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                }
            }
            // SwiftUI has a space between the title and the list. This brings up the list.
            .padding(.top, -8)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                MenuNavBarView()
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    router.navigate(to: .userProfilePage)
                }, label: {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(appGreen)
                })
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if !hasMenuData {
                getMenuData()
            }
        }
    }
    
    // MARK: Helper Functions
    
    private func getMenuData() {
        // Clear existing Core Data
        controller.clear()
        
        // Fetch request
        let urlString: String = "https://raw.githubusercontent.com/Meta-Mobile-Developer-PC/Working-With-Data-API/main/menu.json"
        let url: URL = URL(string: urlString)!
        let urlRequest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, response, error in
            guard let data = data else {
                print("No data received.")
                return
            }
            
            do {
                let menu = try JSONDecoder().decode(MenuList.self, from: data)
                saveMenuData(menu)
            } catch {
                print("Failed to decode data: \(error.localizedDescription)")
            }
        }).resume()
    }
    
    private func saveMenuData(_ menu: MenuList) {
        for item in menu.menu {
            let dish = Dish(context: viewContext)
            dish.price = item.price
            dish.title = item.title
            dish.image = item.image
            dish.desc = item.description
        }
        
        do {
            try viewContext.save()
            hasMenuData = true
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    private func buildPredicate() -> NSPredicate {
        if searchText == "" {
            return NSPredicate.init(value: true)
        }
        return NSPredicate(format: "title CONTAINS[cd] %@", searchText)
    }
    
    private func buildSortDescriptors() -> [NSSortDescriptor] {
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCompare))
        return [sortDescriptor]
    }
}

// MARK: SubViews

struct MenuNavBarView: View {
    var body: some View {
        HStack {
            Image("littleLemon")
                .resizable()
                .frame(width: 200)
        }
    }
}

struct HeroView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Little Lemon")
                .foregroundColor(appYellow)
                .font(.custom("American Typewriter Semibold", size: 36))
            Text("Chicago")
                .foregroundColor(.white)
                .font(.system(size: 26, weight: .medium, design: .monospaced))
                .padding(.bottom, 12)
            Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .medium, design: .monospaced))
            
            TextField("Search Menu", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color(.darkGray), lineWidth: 2)
                }
                .padding(.bottom, 8)
        }
        .padding()
        .background(appGreen)
    }
}

struct OrderMenuView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("ORDER FOR DELIVERY!")
                .font(.system(size: 16, weight: .bold, design: .monospaced))
            
            ScrollView(.horizontal) {
                HStack {
                    Button("Starters") {
                      print("Show Starters")
                    }
                    .padding()
                    .foregroundColor(appGreen)
                    .fontWeight(.bold)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Button("Mains") {
                      print("Show Mains")
                    }
                    .padding()
                    .foregroundColor(appGreen)
                    .fontWeight(.bold)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    
                    Button("Desserts") {
                      print("Show Desserts")
                    }
                    .padding()
                    .foregroundColor(appGreen)
                    .fontWeight(.bold)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)

                    Button("Drinks") {
                      print("Show Drinks")
                    }
                    .padding()
                    .foregroundColor(appGreen)
                    .fontWeight(.bold)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
            }
            .scrollIndicators(.hidden)
        }
    }
}

struct MenuListView: View {
    var item: Dish
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.title ?? "")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                Text(item.desc ?? "")
                    .font(.system(size: 14))
                    .foregroundColor(appGreen)
                    .padding([.top, .bottom, .trailing], 4)
                Text("$\(item.price ?? "").00")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(appGreen)
            }
            Spacer()
            
            AsyncImage(url: URL(string: item.image ?? "")) { result in
                result
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray
            }
            .frame(width: 50, height: 60)
            .padding(.leading, 8)
        }
    }
}

