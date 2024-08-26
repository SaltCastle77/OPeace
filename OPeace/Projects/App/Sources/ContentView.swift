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





struct ContentViews: View {
    @State private var selectedCardIndex: Int = 0
    @State private var cardOffsets: [CGFloat] = Array(repeating: 0, count: 5)
    
    var body: some View {
        ScrollViewReader { proxy in
            Spacer()
            
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(0..<5) { index in
                        CarouselCardView()
                            .frame(height: 600) // Adjust this based on your design
                            .background(GeometryReader { geo in
                                Color.clear
                                    .preference(key: CardOffsetPreferenceKey.self, value: geo.frame(in: .global).midY)
                            })
                            .onPreferenceChange(CardOffsetPreferenceKey.self) { offset in
                                cardOffsets[index] = offset
                                centerOnCardIfNecessary(proxy: proxy)
                            }
                    }
                }
            }
            .onChange(of: selectedCardIndex) { index in
                withAnimation(.easeInOut) {
                    proxy.scrollTo(index, anchor: .center)
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
    
    private func centerOnCardIfNecessary(proxy: ScrollViewProxy) {
        let screenHeight = UIScreen.main.bounds.height
        for (index, offset) in cardOffsets.enumerated() {
            if offset > screenHeight / 3 && offset < screenHeight * 2 / 3 {
                if selectedCardIndex != index {
                    selectedCardIndex = index
                }
                break
            }
        }
    }
}

struct CarouselCardView: View {
    var body: some View {
        VStack(spacing: 16) {
            // Example Header content
            HStack {
                Text("빵미")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                Spacer()
                Text("개발 | Z세대")
                    .font(.system(size: 14))
                    .foregroundColor(.green)
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Emoji and Question
            Text("😮‍💨")
                .font(.system(size: 64))

            Text("퇴사할까 환승이직할까?")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)

            HStack {
                OptionButton(title: "퇴사", option: "A")
                OptionButton(title: "환승이직", option: "B")
            }
            
            Spacer()
            
            // 글쓰기 Button
            HStack {
                Spacer()
                Button(action: {
                    // Action for 글쓰기 button
                }) {
                    Text("글쓰기")
                        .font(.system(size: 20, weight: .bold))
                        .frame(width: 120, height: 48)
                        .background(Color.white)
                        .cornerRadius(24)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 16)
                Spacer()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.9))
        .cornerRadius(16)
    }
}

struct OptionButton: View {
    var title: String
    var option: String

    var body: some View {
        Button(action: {
            // Handle option selection
        }) {
            HStack {
                Text(option)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)

                Spacer()

                Text(title)
                    .font(.system(size: 18))
                    .foregroundColor(.black)
            }
            .padding()
            .background(Color.green)
            .cornerRadius(24)
        }
        .frame(height: 48)
    }
}

struct CardOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    BlockUserView(store: Store(initialState: BlockUser.State(), reducer: {
        BlockUser()
    }), backAction: {})
    
}
    

#Preview {
    ContentViews()
}


