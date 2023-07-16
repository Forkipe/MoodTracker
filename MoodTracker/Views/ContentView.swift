//
//  ContentView.swift
//  MoodTracker
//
//  Created by Марк Горкій on 16.07.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order:.reverse)]) var mood: FetchedResults<Mood>
    
    @State private var showAddView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                List{
                    ForEach(mood) { mood in
                        HStack{
                            if mood.name == "Sad"{
                                Image(systemName: "hand.thumbsdown.fill")
                            } else if mood.name == "OK" {
                                Image(systemName: "hand.thumbsup")
                            } else {
                                Image(systemName: "hand.thumbsup.fill")
                            }
                            VStack(alignment: .leading, spacing: 6) {
                                Text("\(mood.name!)")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                            Text(calcTimeSince(date: mood.date!))
                                .foregroundColor(.gray)
                                .italic()
                        }
                    }
                    .onDelete(perform: deleteMood)
                }
                .listStyle(.plain)
            }
            .navigationTitle("MoodTracker")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showAddView.toggle()
                    } label: {
                        Label("Add Mood", systemImage: "plus.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
            }
            .sheet(isPresented: $showAddView) {
                AddMoodView()
            }
        }
        .navigationViewStyle(.stack)
    }
    private func deleteMood(offsets: IndexSet) {
        withAnimation{
            offsets.map {mood[$0]}.forEach(managedObjContext.delete)
            
            DataController().save(context: managedObjContext)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
