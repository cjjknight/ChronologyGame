import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State private var timeline: [ChronologyEvent] = []
    @State private var events: [ChronologyEvent] = allEvents
    @State private var currentEvent: ChronologyEvent?
    @State private var placementResult: String?
    @State private var score: Int = 0
    @State private var gameEnded: Bool = false
    @State private var draggingEvent: ChronologyEvent?
    @State private var dropIndex: Int?
    @State private var highlightedDropIndex: Int?
    @State private var showingInstructions = false

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
                HStack {
                    Spacer()
                    Button(action: {
                        showingInstructions.toggle()
                    }) {
                        Image(systemName: "questionmark.circle")
                            .font(.largeTitle)
                            .padding()
                    }
                    .sheet(isPresented: $showingInstructions) {
                        InstructionsView()
                    }
                }

                Text("Chronology Game")
                    .font(.largeTitle)
                    .padding()

                Text("Score: \(score)")
                    .font(.title)
                    .padding()

                ScrollView(.horizontal) {
                    HStack {
                        // Dot at the start
                        if let draggingEvent = draggingEvent, highlightedDropIndex == 0 {
                            eventView(draggingEvent)
                        } else {
                            Circle()
                                .fill(highlightedDropIndex == 0 ? Color.green : Color.gray)
                                .frame(width: 30, height: 30)
                                .onDrop(of: [UTType.plainText.identifier], delegate: DropViewDelegate(currentEvent: $currentEvent, timeline: $timeline, dropIndex: 0, dropTargetIndex: $dropIndex, highlightedDropIndex: $highlightedDropIndex, onDrop: handleDrop))
                                .padding(.horizontal, 4)
                        }

                        ForEach(0..<timeline.count, id: \.self) { index in
                            HStack {
                                // Event in the timeline
                                VStack {
                                    Text(timeline[index].description)
                                    Text("\(timeline[index].year)")
                                }
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.blue, lineWidth: 2)
                                )
                                .padding(.horizontal, 4)
                                
                                // Dot between events
                                if let draggingEvent = draggingEvent, highlightedDropIndex == index + 1 {
                                    eventView(draggingEvent)
                                } else {
                                    Circle()
                                        .fill(highlightedDropIndex == index + 1 ? Color.green : Color.gray)
                                        .frame(width: 30, height: 30)
                                        .onDrop(of: [UTType.plainText.identifier], delegate: DropViewDelegate(currentEvent: $currentEvent, timeline: $timeline, dropIndex: index + 1, dropTargetIndex: $dropIndex, highlightedDropIndex: $highlightedDropIndex, onDrop: handleDrop))
                                        .padding(.horizontal, 4)
                                }
                            }
                        }
                    }
                    .padding()
                }

                Spacer()

                if let currentEvent = currentEvent {
                    VStack {
                        Text(currentEvent.description)
                    }
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding()
                    .onDrag {
                        self.draggingEvent = currentEvent
                        return NSItemProvider(object: NSString(string: currentEvent.description))
                    }
                    
                    Text("Drag this event to the correct position in the timeline and click Submit")
                        .font(.headline)
                        .padding()
                    
                    Button(action: {
                        if let dropIndex = dropIndex {
                            placeEvent(at: dropIndex)
                            highlightedDropIndex = nil
                        }
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    .padding()
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
        if let firstEvent = events.randomElement() {
            timeline.append(firstEvent)
            events.removeAll { $0.id == firstEvent.id }
        }
        currentEvent = events.randomElement()
    }

    func placeEvent(at index: Int) {
        guard let event = draggingEvent else { return }

        var correctPosition = false
        if index == 0 {
            if event.year < timeline.first?.year ?? Int.max {
                timeline.insert(event, at: 0)
                correctPosition = true
            }
        } else if index == timeline.count {
            if event.year > timeline.last?.year ?? Int.min {
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

        if let eventIndex = events.firstIndex(where: { $0.id == event.id }) {
            events.remove(at: eventIndex)
        }

        draggingEvent = nil
        highlightedDropIndex = nil

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            placementResult = nil
            getNextEvent()
        }
    }

    func handleDrop(dropIndex: Int) {
        self.dropIndex = dropIndex
    }

    func getNextEvent() {
        if events.isEmpty {
            gameEnded = true
        } else {
            currentEvent = events.randomElement()
            dropIndex = nil
            draggingEvent = nil
        }
    }

    func shuffleEvents() {
        events.shuffle()
    }

    func resetGame() {
        timeline = []
        events = allEvents
        shuffleEvents()
        score = 0
        gameEnded = false
        setupInitialEvent()
    }

    private func eventView(_ event: ChronologyEvent) -> some View {
        VStack {
            Text(event.description)
        }
        .padding()
        .background(Color.green)
        .cornerRadius(10)
        .foregroundColor(.white)
        .padding(.horizontal, 4)
    }
}

struct DropViewDelegate: DropDelegate {
    @Binding var currentEvent: ChronologyEvent?
    @Binding var timeline: [ChronologyEvent]
    var dropIndex: Int
    @Binding var dropTargetIndex: Int?
    @Binding var highlightedDropIndex: Int?
    var onDrop: (Int) -> Void

    func performDrop(info: DropInfo) -> Bool {
        onDrop(dropIndex)
        return true
    }

    func dropEntered(info: DropInfo) {
        dropTargetIndex = dropIndex
        highlightedDropIndex = dropIndex
    }

    func dropExited(info: DropInfo) {
        dropTargetIndex = dropIndex // Keep the drop target index highlighted
    }

    func validateDrop(info: DropInfo) -> Bool {
        return true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
