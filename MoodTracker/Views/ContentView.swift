//
//  ContentView.swift
//  MoodTracker
//
//  Created by Марк Горкій on 16.07.2023.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order:.reverse)]) var mood: FetchedResults<Mood>
    
    @State private var showAddView: Bool = false
    
    var body: some View {
        var a = pointsRating()
        NavigationView {
            VStack(alignment: .leading) {
                VStack {
                    Text("Daily mood rating :")
                        .offset(x:-13, y:-7)
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(Color.gray)
                        
                    HStack {
                        Spacer().frame(width: 15)
                       
                        if a == 0 {
                            
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            
                        } else if a == 1 {
                            
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            
                        } else if a == 2 {
                            
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            
                        } else if a == 3 {
                            
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star").foregroundColor(.gray)
                            Image(systemName: "star").foregroundColor(.gray)
                            
                        } else if a == 4 {
                            
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star").foregroundColor(.gray)
                            
                        } else {
                            
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            Image(systemName: "star.fill").foregroundColor(.yellow)
                            
                        }
                        Text("\(a)/5")
                            .font(.subheadline)
                            .fontWeight(.light)
                            .foregroundColor(Color.gray)
                    }
                }
                List{
                    ForEach(mood) { mood in
                        NavigationLink(destination: EditMoodView(mood: mood)) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).opacity(0.4)
                                    .ignoresSafeArea()
                                    .foregroundColor(.black)
                                    .frame(width: 350, height: 55)
                                HStack {
                                    if mood.name == "Sad" {
                                        Image(systemName: "hand.thumbsdown.circle")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame(width:35, height:35)
                                            .offset(x:7)
                                            
                                    } else if mood.name == "OK" {
                                        Image(systemName: "hand.thumbsup.circle")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame(width:35, height:35)
                                            .offset(x:7)
                                        
                                    } else {
                                        Image(systemName: "face.smiling")
                                            .resizable()
                                            .foregroundColor(.white)
                                            .frame(width:35, height:35)
                                            .offset(x:7)
                                            
                                            
                                    }
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("\(mood.name!)")
                                            .foregroundColor(.white)
                                            .fontWeight(.bold)
                                        Text("\(Int(mood.points))").foregroundColor(.white)
                                    }.offset(x: 10)
                                    Spacer()
                                    Text(calcTimeSince(date: mood.date!)).offset(x:-15)
                                        .foregroundColor(.white)
                                        .italic()
                                }
                            }
                        }
                    }
                    .onDelete(perform: deleteMood)
                    .background( RoundedRectangle(cornerRadius: 10)
                        .offset(x: -8)
                        .opacity(0.4)
                        .ignoresSafeArea()
                        .foregroundColor(.blue)
                        .frame(width: 350, height: 55))
                    
                }
                    .listStyle(.plain)
                
            }
            .onAppear{
                scheduleNotification()
            }
            
            .onAppear {
                areNotificationsEnabled { enabled in
                    if enabled {
                        print("Notifications are enabled")
                    } else {
                       requestNotificationAuthorization()
                    }
                }
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
    
    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification authorization: \(error.localizedDescription)")
            } else if granted {
                print("All set!")
            } else {
                print("User denied notification")
            }
        }
    }
    
    private func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "MoodTracker"
        content.body = "Set your mood for this hour!"
        
        let timeInterval = 60 * 60
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterval), repeats: true)
        
        let request = UNNotificationRequest(identifier: "NotificationIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    
    func areNotificationsEnabled(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let areEnabled = settings.authorizationStatus == .authorized && settings.alertSetting == .enabled
                completion(areEnabled)
            }
        }
    }
    private func pointsRating()-> Int {
        var avrg = 0
        var count = mood.count
                    for item in mood {
                        if Calendar.current.isDateInToday(item.date!) {
                            if count == 0 {
                                avrg = -1
                            } else if count == 1 {
                                avrg = avrg + Int(item.points) - 1
                            } else {
                                avrg = avrg + Int(item.points) / count
                            }
                        }
                    }
        return avrg + 1
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
