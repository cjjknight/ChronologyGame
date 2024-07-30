import SwiftUI

struct ContentView: View {
    @State private var timeline: [ChronologyEvent] = []
    @State private var events: [ChronologyEvent] = [
        ChronologyEvent(description: "First Moon Landing", year: 1969),
        ChronologyEvent(description: "Declaration of Independence", year: 1776),
        ChronologyEvent(description: "Fall of the Berlin Wall", year: 1989),
        ChronologyEvent(description: "Invention of the Telephone", year: 1876)
    ]
    @State private var currentEvent: ChronologyEvent?
    @State private var placementResult: String?

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
                
                Text("Place this event:")
                    .font(.headline)
                    .padding()
                
                HStack {
                    ForEach(0...timeline.count, id: \.self) { index in
                        Button(action: {
                            placeEvent(at: index)
                        }) {
                            Text(index == timeline.count ? "End" : "\(index + 1)")
                                .padding()
                                .background(Color.orange)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                        }
                        .padding(2)
                    }
                }
            }

            Spacer()

            if let result = placementResult {
                Text(result)
                    .foregroundColor(result == "Correct!" ? .green : .red)
                    .padding()
            }
        }
        .onAppear(perform: setupInitialEvent)
    }

    func setupInitialEvent() {
        currentEvent = events.randomElement()
    }

    func placeEvent(at index: Int) {
        guard let event = currentEvent else { return }

        var correctPosition = false
        if timeline.isEmpty || index == timeline.count {
            timeline.append(event)
            correctPosition = true
        } else if index == 0 {
            if event.year < timeline.first!.year {
                timeline.insert(event, at: 0)
                correctPosition = true
            }
        } else if index == timeline.count {
            if event.year > timeline.last!.year {
                timeline.append(event)
                correctPosition = true
            }
        } else {
            if event.year > timeline[index - 1].year && event.year < timeline[index].year {
                timeline.insert(event, at: index)
                correctPosition = true
            }
        }

        if correctPosition {
            placementResult = "Correct!"
        } else {
            placementResult = "Incorrect!"
        }

        if let index = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: index)
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            placementResult = nil
            getNextEvent()
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
