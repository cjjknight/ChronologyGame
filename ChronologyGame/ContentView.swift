import SwiftUI

struct ContentView: View {
    @State private var timeline: [Event] = []
    @State private var events: [Event] = [
        Event(description: "First Moon Landing", year: 1969),
        Event(description: "Declaration of Independence", year: 1776),
        Event(description: "Fall of the Berlin Wall", year: 1989),
        Event(description: "Invention of the Telephone", year: 1876)
    ]
    @State private var currentEvent: Event?
    
    var body: some View {
        VStack {
            Text("Chronology Game")
                .font(.largeTitle)
                .padding()
            
            ScrollView(.horizontal) {
                HStack {
                    ForEach(timeline) { event in
                        VStack {
                            Text(event.description)
                            Text("\(event.year)")
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                }
                .padding()
            }
            
            Spacer()
            
            if let currentEvent = currentEvent {
                VStack {
                    Text(currentEvent.description)
                    Text("\(currentEvent.year)")
                }
                .padding()
                .background(Color.green)
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding()
            }
            
            Spacer()
            
            Button(action: {
                placeEvent()
                getNextEvent()
            }) {
                Text("Place Event")
                    .padding()
                    .background(Color.orange)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .onAppear(perform: setupInitialEvent)
    }
    
    func setupInitialEvent() {
        currentEvent = events.randomElement()
    }
    
    func placeEvent() {
        guard let event = currentEvent else { return }
        // Implement logic to place event in the correct position
        if timeline.isEmpty {
            timeline.append(event)
        } else {
            var inserted = false
            for i in 0..<timeline.count {
                if event.year < timeline[i].year {
                    timeline.insert(event, at: i)
                    inserted = true
                    break
                }
            }
            if !inserted {
                timeline.append(event)
            }
        }
        // Remove the placed event from the events list
        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }
    }
    
    func getNextEvent() {
        currentEvent = events.randomElement()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
