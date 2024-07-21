import SwiftUI
import DesignSystem

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


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
