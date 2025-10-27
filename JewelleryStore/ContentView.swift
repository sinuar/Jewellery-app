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

                    // Custom carousel with snapping
                    GeometryReader { geometry in
                        let totalWidth = geometry.size.width
                        
                        SnapCarouselView(
                            items: Array(0..<4),
                            cardWidth: cardWidth,
                            cardSpacing: cardSpacing,
                            totalWidth: totalWidth,
                            currentIndex: $currentIndex
                        ) { index in
                            ZStack {
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(Color.white.opacity(0.95))
                                    .shadow(radius: 6)
                                Text("Category \(index + 1)")
                                    .font(.title)
                                    .foregroundColor(.black)
                            }
                            .frame(width: cardWidth, height: 480)
                        }
                    }
                    .frame(height: 520)
                    .padding(.top, 16)

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

// Snap Carousel View with proper scrolling behavior
struct SnapCarouselView<Content: View, T: Hashable>: View {
    let items: [T]
    let cardWidth: CGFloat
    let cardSpacing: CGFloat
    let totalWidth: CGFloat
    @Binding var currentIndex: Int
    let content: (T) -> Content
    
    @State private var gestureOffset: CGFloat = 0
    @State private var isDragging = false
    
    private let totalCardWidth: CGFloat
    private let leadingPadding: CGFloat
    
    init(
        items: [T],
        cardWidth: CGFloat,
        cardSpacing: CGFloat,
        totalWidth: CGFloat,
        currentIndex: Binding<Int>,
        @ViewBuilder content: @escaping (T) -> Content
    ) {
        self.items = items
        self.cardWidth = cardWidth
        self.cardSpacing = cardSpacing
        self.totalWidth = totalWidth
        self._currentIndex = currentIndex
        self.content = content
        self.totalCardWidth = cardWidth + cardSpacing
        self.leadingPadding = (totalWidth - totalCardWidth) / 2
    }
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: cardSpacing) {
                    ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                        content(item)
                            .id(index)
                    }
                }
                .padding(.horizontal, leadingPadding)
            }
            .content.offset(x: gestureOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        isDragging = true
                        gestureOffset = value.translation.width
                    }
                    .onEnded { value in
                        isDragging = false
                        let predictedEndOffset = value.predictedEndTranslation.width
                        let velocity = abs(predictedEndOffset) > 500 ? predictedEndOffset : 0
                        
                        // Calculate target index based on drag velocity and direction
                        let dragThreshold: CGFloat = 50
                        var targetIndex = currentIndex
                        
                        if abs(value.translation.width) > dragThreshold || abs(velocity) > 500 {
                            if value.translation.width > 0 || velocity > 0 {
                                // Swiping right - go to previous card
                                targetIndex = max(0, currentIndex - 1)
                            } else {
                                // Swiping left - go to next card
                                targetIndex = min(items.count - 1, currentIndex + 1)
                            }
                        }
                        
                        // Update current index and snap to position
                        currentIndex = targetIndex
                        
                        // Animate to the target card
                        withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                            proxy.scrollTo(targetIndex, anchor: .center)
                        }
                        
                        gestureOffset = 0
                    }
            )
            .onChange(of: currentIndex) { oldValue, newValue in
                // Only programmatically scroll if not currently dragging
                if !isDragging {
                    withAnimation(.interpolatingSpring(stiffness: 300, damping: 30)) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            .onAppear {
                // Center the first item on appear
                proxy.scrollTo(0, anchor: .center)
            }
        }
    }
}
#Preview {
    ContentView()
}
