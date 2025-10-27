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
    
    private let cardWidth: CGFloat = UIScreen.main.bounds.width * 0.82
    private let cardSpacing: CGFloat = 16
    private var totalCardWidth: CGFloat {
        cardWidth + cardSpacing
    }
    
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
                        .padding(.top, 32)

                    // Carousel implemented with TabView + selection binding for reliable paging
                    TabView(selection: $currentIndex) {
                        ForEach(0..<4) { index in
                            let imageName = ["rings01", "necklace01", "bracelet01", "earrings01"][index]
                            let categoryName = ["Rings", "Necklaces", "Bracelets", "Earrings"][index]
                            
                            ZStack {
                                Image(imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: cardWidth, height: 480)
                                    .clipShape(RoundedRectangle(cornerRadius: 24))
                                
                                // Gradient overlay for text visibility
                                LinearGradient(
                                    gradient: Gradient(colors: [.clear, .black.opacity(0.5)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                
                                // Category name at the bottom
                                VStack {
                                    Spacer()
                                    Text(categoryName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .padding(.bottom, 24)
                                }
                            }
                            .frame(width: cardWidth, height: 480)
                            .shadow(radius: 8)
                            .padding(.vertical, 12)
                            .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never)) // Hide built-in page indicators
                    .frame(height: 520)
                    .padding(.top, 16)
                    // Add horizontal padding so neighboring cards peek
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.09)

                    
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


#Preview {
    ContentView()
}
