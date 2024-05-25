import SwiftUI
import AVKit

struct ContentView: View {
    @State var selectedTab: Tab = .house
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    PantryItemsView()
                        .tabItem {
                            Image(systemName: "house")
                        }
                        .tag(Tab.house)
                    
                    LaunchCameraScreen()
                        .tabItem {
                            Image(systemName: "camera")
                        }
                        .tag(Tab.camera)
                    
                    Text("Recipe Suggestion")
                        .tabItem {
                            Image(systemName: "leaf")
                        }
                        .tag(Tab.leaf)
                    
                    ProfileSectionView()
                        .tabItem {
                            Image(systemName: "person")
                        }
                        .tag(Tab.person)
                }
            }
            VStack {
                Spacer()
                CustomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    ContentView()
}
