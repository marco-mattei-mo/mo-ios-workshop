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
                VStack {
                    Text(error)
                    Button("Try again") {
                        Task {
                            await viewModel.loadPeopleList()
                        }
                    }
                }
            } else {
                List(viewModel.people, id: \.name) { people in
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
