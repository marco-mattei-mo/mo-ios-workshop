//
//  PeopleListViewModel.swift
//  iOSWorkshop
//
//  Created by Mattei, Marco-MIGROSONLINE on 12.12.22.
//

import SwiftUI
import Combine

class PeopleListViewModel: ObservableObject {
    @Published var people: [People] = []
    @Published var loadError: String?
    let findPeopleListUseCase: FindPeopleListUseCase
    @Published var sortBy: SortingOption = .name
    private var cancellables = Set<AnyCancellable>()
    
    enum SortingOption: String, CaseIterable {
        case name = "Name"
        case height = "Height"
    }
    
    init(findPeopleListUseCase: FindPeopleListUseCase) {
        self.findPeopleListUseCase = findPeopleListUseCase
        
        $sortBy
            .receive(on: DispatchQueue.main)
            .dropFirst()
            .sink { [weak self] selectedSorting in
                guard let self else { return }
                self.sortPeopleListBy(selectedSorting: selectedSorting)
            }
            .store(in: &cancellables)
    }
    
    // Part 5 - Load the people list and handle the error by assigning it to the loadError variable
    // ⚠️ Do not forget to sort the people list by the currently selected sorting value once the list is loaded.
    @MainActor func loadPeopleList() async {
        do {
            people = try await findPeopleListUseCase.execute()
            sortPeopleListBy(selectedSorting: sortBy)
        } catch {
            loadError = String(describing: error)
        }
    }
    
    // Part 5 - Sort the people list according to the selectedSorting value
    private func sortPeopleListBy(selectedSorting: SortingOption) {
        switch selectedSorting {
        case .name:
            self.people.sort(by: { $0.name < $1.name })
        case .height:
            self.people.sort(by: { $0.height < $1.height })
        }
    }
    
}
