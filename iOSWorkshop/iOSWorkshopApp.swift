//
//  iOSWorkshopApp.swift
//  iOSWorkshop
//
//  Created by Mattei, Marco-MIGROSONLINE on 12.12.22.
//

import SwiftUI

@main
struct iOSWorkshopApp: App {
    var body: some Scene {
        WindowGroup {
            PeopleListView(viewModel: PeopleDIContainer.makePeopleListViewModel())
        }
    }
}
