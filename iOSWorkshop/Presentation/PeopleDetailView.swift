//
//  ContentView.swift
//  iOSWorkshop
//
//  Created by Mattei, Marco-MIGROSONLINE on 12.12.22.
//

import SwiftUI

struct PeopleDetailView: View {
    var viewModel: People
    @State var darkMode = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.name)
                .font(.largeTitle)
                .padding(.bottom, 24)
            HStack {
                Text(String("Height: \(viewModel.height)cm"))
                Spacer()
                Text(String("Weight: \(viewModel.mass)kg"))
            }
            .font(.subheadline)
            .padding(.bottom, 16)
            Text("Hair color: \(viewModel.hairColor)")
            Text("Skin color: \(viewModel.skinColor)")
            Text("Eye color: \(viewModel.eyeColor)")
            Text("Birth year: \(viewModel.birthYear)")
            Text("Gender: \(viewModel.gender)")
            Spacer()
        }
        .padding()
        .navigationTitle(viewModel.name)
        .navigationBarTitleDisplayMode(.inline)
    }

}

struct PeopleDetailView_Previews: PreviewProvider {
    
    static var previews: some View {
        let viewModel = People(name: "name", height: 180, mass: 100, hairColor: "brown", skinColor: "white", eyeColor: "blue", birthYear: "1900", gender: "male")
        
        return PeopleDetailView(viewModel: viewModel)
    }
}
