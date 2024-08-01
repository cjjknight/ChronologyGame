import SwiftUI

struct InstructionsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("How to Play Chronology Game")
                .font(.largeTitle)
                .padding(.bottom, 10)
            Text("1. A timeline with one event will be displayed.")
            Text("2. Drag the current event to the correct position on the timeline.")
            Text("3. Release the event to place it on the timeline.")
            Text("4. Click the Submit button to check if the event is in the correct position.")
            Text("5. If correct, the event will be added to the timeline. If incorrect, try again.")
            Text("6. Score points for correct placements and try to complete the timeline.")
            Spacer()
        }
        .padding()
        .navigationBarTitle("Instructions", displayMode: .inline)
    }
}
