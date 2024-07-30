import SwiftUI

struct ContentView: View {
    @State private var timeline: [ChronologyEvent] = []
    @State private var events: [ChronologyEvent] = initialEvents
    @State private var currentEvent: ChronologyEvent?
    @State private var placementResult: String?
    @State private var score: Int = 0
    @State private var gameEnded: Bool = false

    var body: some View {
        VStack {
            if gameEnded {
                VStack {
                    Text("Game Over")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Final Score: \(score)")
                        .font(.title)
                        .padding()

                    Button(action: {
                        resetGame()
                    }) {
                        Text("Play Again")
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
            } else {
                Text("Chronology Game")
                    .font(.largeTitle)
                    .padding()

                Text("Score: \(score)")
                    .font(.title)
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
        }
        .onAppear(perform: setupInitialEvent)
    }

    func setupInitialEvent() {
        shuffleEvents()
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
            score += 10 // Increase score for correct placement
        } else {
            placementResult = "Incorrect!"
            score -= 5 // Decrease score for incorrect placement
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
        if events.isEmpty {
            gameEnded = true
        } else {
            currentEvent = events.randomElement()
        }
    }

    func shuffleEvents() {
        events.shuffle()
    }

    func resetGame() {
        timeline = []
        events = initialEvents
        shuffleEvents()
        score = 0
        gameEnded = false
        setupInitialEvent()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
