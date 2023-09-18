import SwiftUI


struct WelcomeView: View {
    @StateObject private var viewModel: ViewModel
    
    var body: some View {
        ZStack {
            gradient
            VStack {
                Text("Music Albums")
                    .foregroundColor(.primary)
                    .font(.largeTitle.weight(.semibold))
                    .shadow(radius: 2)
                    .padding(.bottom, 1)
                Text("Rediscover your old music.")
                    .foregroundColor(.primary)
                    .font(.title2.weight(.medium))
                    .multilineTextAlignment(.center)
                    .shadow(radius: 1)
                    .padding(.bottom, 16)
                Text(viewModel.explanatoryText)
                    .foregroundColor(.primary)
                    .font(.title3.weight(.medium))
                    .multilineTextAlignment(.center)
                    .shadow(radius: 1)
                    .padding([.leading, .trailing], 32)
                    .padding(.bottom, 16)
                if let secondaryExplanatoryText = viewModel.secondaryExplanatoryText {
                    Text(secondaryExplanatoryText)
                        .foregroundColor(.primary)
                        .font(.title3.weight(.medium))
                        .multilineTextAlignment(.center)
                        .shadow(radius: 1)
                        .padding([.leading, .trailing], 32)
                        .padding(.bottom, 16)
                }
                if viewModel.showButton {
                    Button {
                        viewModel.handleButtonPressed()
                    } label: {
                        Text(viewModel.buttonText)
                            .padding([.leading, .trailing], 10)
                    }
                    .buttonStyle(.prominent)
                    .colorScheme(.light)
                }
            }
            .colorScheme(.dark)
        }
    }
    
    private var gradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: (130.0 / 255.0), green: (109.0 / 255.0), blue: (204.0 / 255.0)),
                Color(red: (130.0 / 255.0), green: (130.0 / 255.0), blue: (211.0 / 255.0)),
                Color(red: (131.0 / 255.0), green: (160.0 / 255.0), blue: (218.0 / 255.0))
            ]),
            startPoint: .leading,
            endPoint: .trailing
        )
        .flipsForRightToLeftLayoutDirection(false)
        .ignoresSafeArea()
    }
    
    fileprivate struct SheetPresentationModifier: ViewModifier {
        @StateObject private var viewModel = ViewModel()
        
        func body(content: Content) -> some View {
            content
                .sheet(isPresented: $viewModel.isWelcomeViewPresented) {
                    WelcomeView(viewModel: viewModel)
                        .interactiveDismissDisabled()
                }
        }
    }
}

extension View {
    func welcomeSheet() -> some View {
        modifier(WelcomeView.SheetPresentationModifier())
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {}.welcomeSheet()
    }
}
