//
//  CustomTabBarView.swift
//  CanineCompanion
//
//  Created by Paulina DeVito on 4/1/24.
//

import SwiftUI
 
enum Tab: String, CaseIterable {
    case house
    case message
    case location
    case gearshape
}
 
struct CustomTabBarView: View {
    @Binding var selectedTab: Tab
    @State private var tabFrames: [CGRect] = Array(repeating: .zero, count: Tab.allCases.count)
 
    private var indicatorColor: Color {
        // Purple color indicator
        return Color(hex: 0xFFB63C)
    }
 
    var body: some View {
        
        
        ZStack {
            Color(.white)
                .edgesIgnoringSafeArea(.all)
            
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.self) { tab in
                    GeometryReader { geometry in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedTab = tab
                            }
                        }) {
                            Image(systemName: selectedTab == tab ? tab.rawValue + ".fill" : tab.rawValue)
                                .foregroundColor(selectedTab == tab ? Color(hex: 0xFFB63C) : .white) // Icons white
                                .font(.system(size: 22))
                                .scaleEffect(selectedTab == tab ? 1.25 : 1.0)
                                .frame(width: geometry.size.width, height: 60, alignment: .center)
                                .onAppear {
                                    // Capture the initial frames
                                    let index = Tab.allCases.firstIndex(of: tab) ?? 0
                                    tabFrames[index] = geometry.frame(in: .global)
                                }
                                .onChange(of: geometry.frame(in: .global)) { newFrame in
                                    // Update the frames if they change
                                    let index = Tab.allCases.firstIndex(of: tab) ?? 0
                                    tabFrames[index] = newFrame
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .background(Color(hex: 0x6A2956))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .fill(indicatorColor) // Keep the indicator purple
                    .frame(width: tabFrames[Tab.allCases.firstIndex(of: selectedTab) ?? 0].size.width, height: 5)
                    .offset(x: calculateOffset(for: selectedTab), y: 0)
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                , alignment: .topLeading
            )
            //.cornerRadius(15)
        }
    }
    
    func calculateOffset(for tab: Tab) -> CGFloat {
        let tabIndex = Tab.allCases.firstIndex(of: tab) ?? 0
        let tabWidth = tabFrames[tabIndex].width
        let screenWidth = UIScreen.main.bounds.width
        let totalTabsWidth = tabWidth * CGFloat(tabFrames.count)
        let sidePadding = (screenWidth - totalTabsWidth) / 2
        let tabOffset = tabFrames[tabIndex].minX
 
        // Calculate the center position of the indicator
        let halfIndicatorWidth = tabWidth / 2
        let centerOffset = tabOffset - sidePadding + halfIndicatorWidth - (tabWidth / 2)
        
        return centerOffset
    }
}
 


#Preview {
    CustomTabBarView(selectedTab: .constant(.house))
}
