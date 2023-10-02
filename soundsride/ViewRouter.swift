
// Based on https://blckbirds.com/post/custom-tab-bar-in-swiftui/

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page
    
    init(defaultPage: Page) {
        self.currentPage = defaultPage
    }
    
}

struct TabBarIcon: View {
    
    @ObservedObject var viewRouter: ViewRouter
    let page: Page
    let width, height: CGFloat
    let systemIconName, tabName: String
    
    
    var body: some View {
        VStack {
            Image(systemName: systemIconName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: height)
                .padding(.top, 10)
            Text(tabName)
                .font(.footnote)
            Spacer()
        }
            .onTapGesture {
                viewRouter.currentPage = page
            }
        .foregroundColor(viewRouter.currentPage == page ? .primary : .secondary)
    }
}

struct TabBar: View {
    var geometry: GeometryProxy
    var viewRouter: ViewRouter
    var tabs: [(label: String, page: Page, iconName: String)]
    
    var body: some View {
        HStack {
            ForEach(tabs, id: \.0) { tab in
                TabBarIcon(
                    viewRouter: viewRouter,
                    page: tab.page, width: geometry.size.width / (CGFloat(tabs.count) + 0.5),
                    height: geometry.size.height / 28,
                    systemIconName: tab.iconName,
                    tabName: tab.label)
            }
            
        }
            .frame(width: geometry.size.width, height: geometry.size.height/8)
            .background(Color("TabBarBackground").shadow(radius: 2))
    }
}

