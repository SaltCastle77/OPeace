import SwiftUI
import DesignSystem
import ISEmojiView
import UIKit

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
    @State var text: String = ""
    ZStack {
        Color.basicWhite
      
        if let image =  Image.emojiToImage(emoji:  "😀") {
            image
                .resizable()
                .scaledToFit()
        }
    }
    
}




