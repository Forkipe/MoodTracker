//
//  ListItemViewModel.swift
//  MoodTracker
//
//  Created by Марк Горкій on 17.07.2023.
//

import SwiftUI
import CoreData

struct ListItemView: View {
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order:.reverse)]) var fetchedResults: FetchedResults<Mood>
    
    var body: some View {
        NavigationView {
            List(fetchedResults) { mood in
                NavigationLink(destination: EditMoodView(mood: mood)) {
                    HStack {
                        if mood.name == "Sad" {
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
            }
        }
    }
}
