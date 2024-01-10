import SwiftUI

import PageLoader

struct ModalPageView: View {
    @Binding var isPresented: Bool
    let page: Page
    
    var body: some View {
        NavigationView {
            PageLoader(page: page)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        Button(action: {
                            isPresented = false
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title3)
                                .foregroundColor(.gray)
                        })
                    }
                }
        }
    }
}
