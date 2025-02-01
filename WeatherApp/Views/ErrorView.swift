import SwiftUI

struct ErrorView: View {
    let error: AppError
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(error.errorDescription ?? "Unknown error")
                .foregroundColor(.red)
            Button("Retry", action: retryAction)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }
}