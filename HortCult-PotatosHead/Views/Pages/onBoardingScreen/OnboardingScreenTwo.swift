import SwiftUI

struct OnboardingScreenTwo: View {
    
    @State private var isNextScreenActive = false
    @State private var jumpToInitalScreen = false
    var hortCultMain: HortCult_PotatosHeadApp?
    @ObservedObject var plantViewModel: PlantViewModel
    
    var body: some View {
        
        NavigationView {
            OnboardingScreen(header: "hortFruitLight",
                             centerImage: "onboardingtwolight",
                             primaryText: "Acompanhe a sua horta",
                             secondaryText: "Tenha uma visão geral do desenvolvimento das duas plantações",
                            
                             actionMainButton: {isNextScreenActive = true},
                             mainButtonType: .two,
                             hidenSecondaryButton: false,
                             actionSecondaryButton: {
                                jumpToInitalScreen = true
                                HortCult_PotatosHeadApp.isFirstLogin = false
            })
            
            .background(
                NavigationLink(destination: OnboardingScreenThree(plantViewModel: plantViewModel), isActive: $isNextScreenActive) { EmptyView()}
 
            )
            .background(
                NavigationLink(destination: MainView(plantViewModel: plantViewModel), isActive: $jumpToInitalScreen) { EmptyView()}
            )
            
            //Navegar para a tela inicial no botao 2
            
        }.navigationBarHidden(true)
    }
}

struct OnboardingScreenTwo_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingScreenTwo(plantViewModel: PlantViewModel())
    }
}
