//
//  ContentView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var showAuth = false
    @State private var currentIndex: Int = 0
    
    var body: some View {
        if isAuthenticated {
            CatalogView()
        } else {
            NavigationView {
                VStack {
                    // Store name at the top
                    Text("Jewellery Store")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, UIScreen.main.bounds.height * 0.04)

                    // Custom carousel with better spacing control
                    CustomCarouselView(currentIndex: $currentIndex)
                        .frame(height: UIScreen.main.bounds.width * 1.2)
                        .padding(.top, UIScreen.main.bounds.height * 0.02)

                    // Page indicators
                    HStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.accentColor : Color.gray.opacity(0.4))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 8)

                    Spacer()

                    // Hidden NavigationLink for programmatic push
                    NavigationLink(destination: AuthenticationView(isAuthenticated: $isAuthenticated), isActive: $showAuth) {
                        EmptyView()
                    }

                    // Bottom button to go to login/registration
                    Button(action: { showAuth = true }) {
                        Text("Get Started")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor.opacity(0.9))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .padding(.horizontal, 48)
                            .padding(.bottom, 32)
                    }
                }
                .navigationBarHidden(true)
            }
        }
    }
}

struct CustomCarouselView: View {
    @Binding var currentIndex: Int
    @State private var offset: CGFloat = 0
    @State private var gestureOffset: CGFloat = 0
    
    private let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.76
    private let cardHeight: CGFloat = UIScreen.main.bounds.width * 1.16
    private let spacing: CGFloat = 16 // Space between cards
    private var totalCardWidth: CGFloat {
        cardWidth + spacing
    }
    
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let leadingPadding = (totalWidth - cardWidth) / 2
            
            ZStack {
                HStack(spacing: spacing) {
                    ForEach(0..<4) { index in
                        let imageName = ["rings01", "necklace01", "bracelet01", "earrings01"][index]
                        let categoryName = ["Rings", "Necklaces", "Bracelets", "Earrings"][index]
                        
                        CardView(
                            imageName: imageName,
                            categoryName: categoryName,
                            width: cardWidth,
                            height: cardHeight
                        )
                    }
                }
                .offset(x: leadingPadding + offset + gestureOffset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            gestureOffset = value.translation.width
                        }
                        .onEnded { value in
                            withAnimation(.spring()) {
                                let dragThreshold: CGFloat = 50
                                
                                if value.translation.width < -dragThreshold && currentIndex < 3 {
                                    currentIndex += 1
                                } else if value.translation.width > dragThreshold && currentIndex > 0 {
                                    currentIndex -= 1
                                }
                                
                                updateOffset()
                                gestureOffset = 0
                            }
                        }
                )
            }
            .onChange(of: currentIndex) { _, _ in
                withAnimation(.spring()) {
                    updateOffset()
                }
            }
            .onAppear {
                updateOffset()
            }
        }
    }
    
    private func updateOffset() {
        offset = -CGFloat(currentIndex) * totalCardWidth
    }
}

struct CardView: View {
    let imageName: String
    let categoryName: String
    let width: CGFloat
    let height: CGFloat
    
    var body: some View {
        ZStack {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 24))
            
            LinearGradient(
                gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: 24))
            
            VStack {
                Spacer()
                Text(categoryName)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom, 24)
            }
        }
        .frame(width: width, height: height)
        .shadow(radius: 8)
    }
}


#Preview {
    ContentView()
}
