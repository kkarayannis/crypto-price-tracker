import SwiftUI

extension View {
    @ViewBuilder func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
