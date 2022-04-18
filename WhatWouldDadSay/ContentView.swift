//
//  ContentView.swift
//  WhatWouldDadSay
//
//  Created by Ben Cochran on 9/28/21.
//

import SwiftUI

struct ContentView: View {
    var imgPrexif = "dad"
    var imageCount = 25
    let sayings = ["If it's worth doing it's worth doing right.",
                   "No!",
                   "Go be a blessing to someone.",
                   "Remember to keep something in your pocket.",
                   "Leave it better than you found it.",
                   "It's a little more complicated than that.",
                   "Don't be a troll!",
                   "Clean your room!",
                   "A little physical exercise will help.",
                   "Time to go surfing!",
                   "What did Mom say?",
                   "I am so excited!",
                   "Treat others with kindness, ALWAYS!",
                   "No, you can't stay home from school.",
                   "Go ride a bike.",
                   "just some mumbling ...",
                   "You can’t have your own truth as the truth is independent of us. What we have is our perspectives.",
                   "Tomorrow is a new day with new graces.",
                   "The first day is always hard.",
                   "\"This this is why we can’t have nice things\" - Taylor Swift",
                   "\"You’re being too loud you need to calm down\" - Taylor Swift",
                   "\"Cause forgiveness is a nice thing to do\" - Taylor Swift",
                   "\"It feels like one of those nights\" - Taylor Swift",
                   "Is everyone okay? Good! Now, how did this happen?",
                   "\"Life should not be a journey to the grave with the intention of arriving safely in a pretty and well preserved body, but rather to skid in broadside in a cloud of smoke, thoroughly used up, totally worn out, and loudly proclaiming Wow! What a Ride!\" - Hunter S. Thompson"
                  ]
    
    @State private var updateEvent : Bool = false;

    //
    // Adding App Init here.
    init (){
        debugPrint ("Init View");
        
        let noteSaying = sayings[ Int.random(in: 0..<sayings.count) ];
        
        // Ask if we can send Notifications, then add. 
        let notificationCenter = UNUserNotificationCenter.current();
        notificationCenter.removeAllPendingNotificationRequests();      // clear any pending notefcation.
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Add Set Up a timer to set a notification");
             
                let noteContent = UNMutableNotificationContent();
                noteContent.title = "What Would Dad Say?";
                noteContent.body = noteSaying;
                noteContent.categoryIdentifier = "alarm";
                noteContent.userInfo = ["customData": "fizzbuzz"];
                noteContent.sound = UNNotificationSound.default;

                // Trigger ever one day from now.
                let noteTrigger = UNTimeIntervalNotificationTrigger (timeInterval: (1440), repeats: false)
                                
                // Create the request
                let uuidString = UUID().uuidString
                let request = UNNotificationRequest(identifier: uuidString,
                            content: noteContent, trigger: noteTrigger)

                // Schedule the request with the system.
                notificationCenter.add(request) { (error) in
                   if error != nil {
                      // Handle any errors.
                       print("Error Adding Notification!")
                   }
                }

            } else {
                print("Don't add Notifications");
            }
        }
    }
    
    var body: some View {
        HStack{
            Spacer()
            ZStack (){
                Color.black
                
                // The Image
                Image("\(imgPrexif)\(Int.random(in: 1 ... imageCount))")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, alignment: .top)
                    //.animation( .easeIn (duration: 0.15) )
                VStack(){
                    Spacer()
                    
                    // Call out saying
                    Text( "\(sayings[ Int.random(in: 0..<sayings.count) ])" )
                        .padding()
                        .foregroundColor(updateEvent ? .white : .white)  // need to find a better way to do this.
                        .font(.system (size: 30.0))
                        .frame(maxWidth: .infinity, alignment: .bottom )
                        .background(Color.black.opacity(0.4))
                        .animation( .easeIn (duration: 0.15) )
                }
            }.onTapGesture {
                debugPrint ("onTap");
                self.updateEvent.toggle();
            }.onShake {
                debugPrint ("onShake");
                self.updateEvent.toggle();
            }
                
            Spacer()
        }
    }
}

// The notification for the shake gesture happens.
extension UIDevice {
    static let deviceDidShakeNotification = Notification.Name(rawValue: "deviceDidShakeNotification")
}

//  Override the default behavior of shake gestures to send our notification instead.
extension UIWindow {
     open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.deviceDidShakeNotification, object: nil)
        }
     }
}

// A view modifier that detects shaking and calls a function of our choosing.
struct DeviceShakeViewModifier: ViewModifier {
    let action: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.deviceDidShakeNotification)) { _ in
                action()
            }
    }
}

// A View extension to make the modifier easier to use.
extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(DeviceShakeViewModifier(action: action))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
            //    .previewInterfaceOrientation(.portrait)
            //    .previewInterfaceOrientation(.landscapeRight)
            ContentView()
            //    .previewInterfaceOrientation(.portraitUpsideDown)
            //    .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
