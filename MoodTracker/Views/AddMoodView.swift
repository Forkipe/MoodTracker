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
    
    var moods = ["Sad", "OK", "Happy"]
    var body: some View {
        Form{
            Section{
                VStack{
                    Picker("Choose your mood for this hour", selection: $name) {
                        ForEach(moods, id: \.self) {
                            Text($0)
                        }
                    }.pickerStyle(.segmented)
                    Spacer()
                        .frame(height: 40.0)
                    HStack{
                        Spacer()
                        Button("Submit") {
                            DataController().AddMood(name: name, context: managedObjContext)
                            dismiss()
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
