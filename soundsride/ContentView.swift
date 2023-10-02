//
//  ContentView.swift
//  soundsride
//
//  Created by Mohamed Kari on 02.09.20.
//  Copyright © 2020 Mohamed Kari. All rights reserved.
//

import SwiftUI
import MapKit
import CoreLocation


enum Page {
     case location
     case record
     case settings
 }

struct ContentView: View {
    @ObservedObject var viewRouter = ViewRouter(defaultPage: .record)
    
    // https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/
    let tabs = [
        (label: "Location", page: Page.location, iconName: "location"),
        (label: "Record", page: Page.record, iconName: "tray.and.arrow.down"),
        (label: "Settings", page: Page.settings, iconName: "gearshape")
    ]

    
    var body: some View {
        GeometryReader{ geometry in
            VStack {
                Spacer()
                switch viewRouter.currentPage {
                    case .location:
                        LocalizationView()
                    case .record:
                        ServiceView()
                    case .settings:
                        Text("Settings")
                }
                Spacer()
                TabBar(geometry: geometry, viewRouter: viewRouter, tabs: tabs)
            }
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
