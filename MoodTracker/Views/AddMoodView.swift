//
//  AddMoodView.swift
//  MoodTracker
//
//  Created by Марк Горкій on 16.07.2023.
//

import SwiftUI

struct AddMoodView: View {
    @Environment (\.managedObjectContext) var managedObjContext
    @Environment(\.dismiss) var dismiss
    
    @State private var name = "OK"
    @State private var points:Double = 0
    
    var moods = ["Sad", "OK", "Happy"]
    
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
                    Picker("Set your mood for this hour", selection: $name) {
                        ForEach(moods, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                    Spacer()
                        .frame(height: 20.0)
                    Text("Points: \(firstNumber)")
                        .font(.headline)
                        .fontWeight(.ultraLight)
                        .multilineTextAlignment(.center)
                    Spacer()
                        .frame(height: 20.0)
                    HStack{
                        Spacer()
                        Button {
                            points = moodPoints
                            DataController().AddMood(name: name, points: points, context: managedObjContext)
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
    
}

struct AddMoodView_Previews: PreviewProvider {
    static var previews: some View {
        AddMoodView()
    }
}
