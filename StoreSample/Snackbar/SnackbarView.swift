import SwiftUI

struct SnackbarView: View {
    let model: Model

    var body: some View {
        Text(model.title)
            .padding()
            .background(.ultraThinMaterial)
            .onTapGesture(perform: model.onTapped)
    }
}
