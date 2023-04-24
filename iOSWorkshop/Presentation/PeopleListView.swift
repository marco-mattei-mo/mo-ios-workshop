//
//  PeopleListView.swift
//  iOSWorkshop
//
//  Created by Mattei, Marco-MIGROSONLINE on 12.12.22.
//

import SwiftUI

struct PeopleListView: View {
    @StateObject var viewModel: PeopleListViewModel
    @State var firstAppear = true
    
    var body: some View {
        NavigationView {
            if let error = viewModel.loadError {
                // TODO: Part 6 - If there is an error, display the error and below it, a button that allows to try again
            } else {
                // TODO: Part 6
                /*
                 Display a list of people that matches the design provided
                 Hints on elements to use:
                 - List
                 - VStack
                 - Text
                 - Rembember, the list of people is in the viewModel
                 
                 When the list appears, if it's the first time it appears, load the people list.
                 
                 Add a pull-to-refresh to the list that will load the list of people
                 
                 The title of the view should be "Star Wars People"
                 
                 For the toolbar item, we will do it together 🙂
                 */
                
                //TODO: Part 7 - When clicking on an item on the list, navigate to the "PeopleDetailView" of that people
            }
        }
    }
}

struct PeopleListView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = PeopleDIContainer.makeFakePeopleListViewModel()
        
        return PeopleListView(viewModel: viewModel)
    }
}
