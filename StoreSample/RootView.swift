import SwiftUI

struct RootView: View {
    let factory = RootFactory()

    var body: some View {
        TabView {
            factory.makeCitiesSearchContainer()
        }
    }
}

#Preview {
    RootView()
}
