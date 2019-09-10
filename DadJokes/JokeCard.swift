//
//  JokeCard.swift
//  DadJokes
//
//  Created by Paul Hudson on 10/09/2019.
//  Copyright © 2019 Hacking with Swift. All rights reserved.
//

import SwiftUI

struct JokeCard: View {
    @Environment(\.managedObjectContext) var moc
    @State var randomNumber = Int.random(in: 1...4)
    @State var showingPunchline = false
    @State var dragAmount = CGSize.zero
    var joke: Joke

    var body: some View {
        VStack {
            GeometryReader { geo in
                VStack {
                    Image("Dad\(self.randomNumber)")
                    Text(self.joke.setup)
                        .font(.largeTitle)
                        .lineLimit(10)
                        .padding([.horizontal])

                    Text(self.joke.punchline)
                        .font(.title)
                        .lineLimit(10)
                        .padding([.horizontal, .bottom])
                        .blur(radius: self.showingPunchline ? 0 : 6)
                        .opacity(self.showingPunchline ? 1 : 0.25)
                }
                .multilineTextAlignment(.center)
                .background(
                    Color.white
                        .shadow(color: .black, radius: 5)
                )
                .onTapGesture {
                    withAnimation {
                        self.showingPunchline.toggle()
                    }
                }
                .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).minX) / 10), axis: (x: 0, y: 1, z: 0))
            }

            Text(joke.rating)
                .font(.system(size: 48))
                .foregroundColor(.white)
        }
        .frame(minHeight: 0, maxHeight: .infinity)
        .frame(width: 300)
        .offset(y: self.dragAmount.height)
        .gesture(
            DragGesture()
                .onChanged { self.dragAmount = $0.translation }
                .onEnded { value in
                    if self.dragAmount.height < -200 {
                        withAnimation {
                            self.dragAmount = CGSize(width: 0, height: -1000)

                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                self.moc.delete(self.joke)
//                                try? self.moc.save()
                            }
                        }
                    } else {
                        self.dragAmount = .zero
                    }
                }
        )
        .animation(.spring())
    }
}

