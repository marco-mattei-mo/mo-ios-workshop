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
                //  Part 6 - If there is an error, display the error and below it, a button that allows to try again
                VStack {
                    Text(error)
                    Button("Try again") {
                        Task {
                            await viewModel.loadPeopleList()
                        }
                    }
                }
            } else {
                // Part 6
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
                
                List(viewModel.people, id: \.name) { people in
                    // Part 7 - When clicking on an item on the list, navigate to the "PeopleDetailView" of that people
                    
                    NavigationLink {
                        PeopleDetailView(viewModel: people)
                    } label: {
                        VStack(alignment: .leading) {
                            Text(people.name)
                            Text(people.birthYear)
                        }
                    }
                }
                .toolbar {
                    ToolbarItem {
                        Picker("Filter", selection: $viewModel.sortBy) {
                            ForEach(PeopleListViewModel.SortingOption.allCases, id: \.self) { filterOption in
                                Text(filterOption.rawValue).tag(filterOption)
                            }
                        }
                    }
                }
                .onAppear {
                    Task {
                        if firstAppear {
                            await viewModel.loadPeopleList()
                            firstAppear = false
                        }
                    }
                }.refreshable {
                    await viewModel.loadPeopleList()
                }
                .navigationTitle("Star Wars People")
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
