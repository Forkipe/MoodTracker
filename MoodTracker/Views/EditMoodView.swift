//
//  EditMoodView.swift
//  MoodTracker
//
//  Created by Марк Горкій on 17.07.2023.
//

import SwiftUI

struct EditMoodView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    var mood: FetchedResults<Mood>.Element
    var moods = ["Sad", "OK", "Happy"]
    
    @State private var name = ""
    @State private var points:Double = 0
    private var moodPoints: Double {
            switch name {
            case "Sad":
                return 1
            case "OK":
                return 3
            case "Happy":
                return 5
            default:
                return 0
            }
        }
    var body: some View {
        let firstNumber = Int(floor(moodPoints))
        Form {
            Section {
                VStack {
                    Picker("Choose your mood for this hour", selection: $name) {
                        ForEach(moods, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                        .onAppear {
                            name = mood.name!
                        }
                    Text("Points: \(firstNumber)")
                }
                HStack{
                    Spacer()
                    Button {
                        points = moodPoints
                        DataController().editMood(mood: mood, points: points, name: name, context: managedObjContext)
                        dismiss()
                    } label: {
                        ZStack {
                           
                            RoundedRectangle(cornerRadius: 10).foregroundColor(.blue)
                                .opacity(0.4)
                                .frame(width: 100, height: 25)
                            Text("Submit")
                                .foregroundColor(.black)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

