import SwiftUI
import DesignSystem

import ComposableArchitecture
import UIKit
import Presentation

public struct ContentView: View {
    public init() {}

    public var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color.lighten100, Color.basicPrimary]),
            startPoint:. topLeading,
            endPoint: .bottomTrailing
        )
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    BlockUserView(store: Store(initialState: BlockUser.State(), reducer: {
        BlockUser()
    }), backAction: {})
    
}
    

#Preview {
    ContentView()
}


