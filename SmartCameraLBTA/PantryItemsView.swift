import SwiftUI
import Combine

// Item struct for each item that will be in the pantry

// TODO: find a way to automatically add image of the item
// TODO: find a way to group items that have all the same fields i.e if it's the same item
struct PantryItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var description: String?
    var quantity: Int
    var EXPDate: Date
}

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    return formatter
}()

struct AddItemView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var itemName = ""
    @State private var desc = ""
    @State private var quant = "0"
    @State private var EXPDate = Date()
    @Binding var pantryItems: [PantryItem]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item Name")) {
                    TextField("Enter item name", text: $itemName)
                }
                Section(header: Text("Item Description")) {
                    TextField("Enter item description", text: $desc)
                }
                Section(header: Text("Item Quantity")) {
                    TextField("Enter item quantity", text: $quant)
                        .keyboardType(.numberPad)
                        .onReceive(Just(quant)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.quant = filtered
                            }
                        }
                }
                Section(header: Text("Item EXP Date")) {
                    DatePicker(selection: $EXPDate, in: Date()..., displayedComponents: .date) {
                        Text("Select EXP Date")
                    }
                }
            }
            .navigationTitle("Add Item")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        if let quantity = Int(quant) {
                            let itemToSave = PantryItem(name: itemName, description: desc, quantity: quantity, EXPDate: EXPDate)
                            pantryItems.append(itemToSave)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    .disabled(itemName.isEmpty || quant.isEmpty)
                }
            }
        }
    }

}

struct PantryItemsView: View {
    @State private var pantryItems: [PantryItem] = []
    @State private var showingAddItemView = false
    @State private var showingItemInfoView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pantryItems) { item in
                    DisclosureGroup(item.name) {
                        Text("Description: \(item.description ?? "No description")")
                        Text("Quantity: \(item.quantity)")
                        Text("EXP Date: \(item.EXPDate, formatter: dateFormatter)")
                    }
                }
            }
            .navigationTitle("Pantry Items")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddItemView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItemView) {
                AddItemView(pantryItems: $pantryItems)
            }
            .onAppear {
                loadPantryItems()
            }
            .onDisappear {
                savePantryItems()
            }
        }
    }
    private func savePantryItems() {
        if let encoded = try? JSONEncoder().encode(pantryItems) {
            UserDefaults.standard.set(encoded, forKey: "pantryItems")
        }
    }
    
    private func loadPantryItems() {
        if let savedItems = UserDefaults.standard.data(forKey: "pantryItems"),
           let decodedItems = try? JSONDecoder().decode([PantryItem].self, from: savedItems) {
            pantryItems = decodedItems
        }
    }
}



#Preview {
    PantryItemsView()
}
