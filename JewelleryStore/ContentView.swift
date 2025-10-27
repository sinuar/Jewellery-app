//
//  ContentView.swift
//  JewelleryStore
//
//  Created by Sinuhe Alvarez Ruedas on 08/10/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var showAuthentication = false
    @State private var currentIndex: Int = 0
    
    var body: some View {
        if isAuthenticated {
            CatalogView()
                .background(Color("AppBackground"))
        } else {
            NavigationStack {
                VStack {
                    // Store name at the top
                    Text("My Jewellery Store")
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

                    // Bottom button to go to login/registration
                    Button(action: { showAuthentication = true }) {
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
                .navigationDestination(isPresented: $showAuthentication) {
                    AuthenticationView(isAuthenticated: $isAuthenticated)
                        .background(Color("AppBackground"))
                }
                .background(Color("AppBackground"))
            }
        }
    }
}

struct CustomCarouselView: View {
    @Binding var currentIndex: Int
    @State private var scrollPosition: Int? = 0
    
    private let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.76
    private let cardHeight: CGFloat = UIScreen.main.bounds.width * 1.16
    private let spacing: CGFloat = 16 // Space between cards
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(0..<4, id: \.self) { index in
                        let imageName = ["rings01", "necklace01", "bracelet01", "earrings01"][index]
                        let categoryName = ["Rings", "Necklaces", "Bracelets", "Earrings"][index]
                        
                        CardView(
                            imageName: imageName,
                            categoryName: categoryName,
                            width: cardWidth,
                            height: cardHeight
                        )
                        .scrollTransition(.animated(.spring)) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.92)
                                .opacity(phase.isIdentity ? 1 : 0.4)
                        }
                        .id(index)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, (UIScreen.main.bounds.width - cardWidth) / 2)
            }
            .scrollPosition(id: $scrollPosition)
            .scrollTargetBehavior(.viewAligned)
            .onChange(of: scrollPosition) { oldValue, newValue in
                if let newValue = newValue {
                    currentIndex = newValue
                }
            }
            .onChange(of: currentIndex) { oldValue, newValue in
                if scrollPosition != newValue {
                    scrollPosition = newValue
                }
            }
            .onAppear {
                scrollPosition = currentIndex
            }
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
