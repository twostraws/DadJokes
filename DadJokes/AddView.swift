//
//  AddView.swift
//  DadJokes
//
//  Created by Paul Hudson on 10/09/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var moc
    @Binding var isPresented: Bool

    @State var setup = ""
    @State var punchline = ""
    @State var rating = ""
    let ratings = ["A", "B", "C"]

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Setup", text: $setup)
                    TextField("Punchline", text: $punchline)

                    Picker("Rating", selection: $rating) {
                        ForEach(ratings, id: \.self) { rating in
                            Text(rating)
                        }
                    }
                }

                Button("Add Joke") {
                    let newJoke = Joke(context: self.moc)
                    newJoke.setup = self.setup
                    newJoke.punchline = self.punchline
                    newJoke.rating = self.rating

                    try? self.moc.save()
                    self.isPresented = false
                }
            }.navigationBarTitle("New Joke")
        }
    }
}
