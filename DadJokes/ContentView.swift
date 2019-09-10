//
//  ContentView.swift
//  DadJokes
//
//  Created by Paul Hudson on 10/09/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

// This was the original table-based content view.
struct OldContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Joke.entity(), sortDescriptors: []) var jokes: FetchedResults<Joke>
    @State var showingAddJoke = false

    var body: some View {
        NavigationView {
            List {
                ForEach(jokes, id: \.setup) { joke in
                    NavigationLink(destination: Text(joke.punchline)) {
                        Text(joke.rating)
                            .font(.headline)
                        Text(joke.setup)
                    }
                }.onDelete(perform: removeJokes)
            }
            .navigationBarTitle("Dad Jokes")
            .navigationBarItems(leading: EditButton(), trailing: Button("Add") {
                self.showingAddJoke.toggle()
            })
        }
        .sheet(isPresented: $showingAddJoke) {
            AddView(isPresented: self.$showingAddJoke).environment(\.managedObjectContext, self.moc)
        }
    }

    func removeJokes(at offsets: IndexSet) {
        for index in offsets {
            let joke = jokes[index]
            moc.delete(joke)
        }

        try? moc.save()
    }
}

// This is the newer custom content view that uses a scroll view
struct ContentView: View {
    @FetchRequest(entity: Joke.entity(), sortDescriptors: []) var jokes: FetchedResults<Joke>
    @State var showingAddJoke = false
    @Environment(\.managedObjectContext) var moc

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(jokes, id: \.setup) { joke in
                        JokeCard(joke: joke)
                    }
                }.padding()
            }

            Button("Add Joke") {
                self.showingAddJoke.toggle()
            }
            .foregroundColor(.white)
            .offset(y: 50)
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showingAddJoke) {
            AddView(isPresented: self.$showingAddJoke).environment(\.managedObjectContext, self.moc)
        }
    }

    func removeJokes(at offsets: IndexSet) {
        for index in offsets {
            let joke = jokes[index]
            moc.delete(joke)
        }

        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
