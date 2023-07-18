//
//  SwiftUIView.swift
//  HortCult-PotatosHead
//
//  Created by userext on 30/05/23.
//


import SwiftUI

struct HomeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var defaults: Defaults
    @State var goToAddPlantScreen: Bool = false
    @State var mokeRemainderList: [Notification] = []
    @State var cardModels: [CardViewModel] = []
    var body: some View {
        ScrollView(.vertical){
            VStack {
                CustomNavBar(hiddenDismissButton: true)
                Spacer()
                ScrollView {
                    HeaderMenu(noticationList: $cardModels )
                    Spacer().frame(height: Service.plant.plants.isEmpty ? 120 : 0)
                }
                Spacer().frame(height: Service.plant.plants.isEmpty ? 120 : 0)
                .padding(.bottom, 20)
                
                CardListView(cards: $cardModels)
            }
            .onAppear() {
                cardModels = []
                let remindersList = Service.notification.notifications.compactMap({ notification in
                    notification
                }).filter { notification in
                    let currentDate = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/yyyy"
                    var dateString = dateFormatter.string(from: currentDate)
                    
                    return (!notification.isResolve && notification.nextTimeToAlert == dateString && notification.notificationPlant != nil)
                }
                
                remindersList.forEach { notification in
                    
                    let notificationDisplayed = HomeViewModel.notificationsTextsToDisplay(notification: notification)
                    let cardModel: CardViewModel = CardViewModel(
                        id: notificationDisplayed.id,
                        title: notificationDisplayed.title,
                        content: notificationDisplayed.description,
                        icon: notificationDisplayed.icon,
                        cardColor: notificationDisplayed.cardColor,
                        backgroudCardColor: notificationDisplayed.backgroudCardColor,
                        textColor: notificationDisplayed.textColor
                    )
                    cardModels.append(cardModel)
                }
            }
        }
        .background(NavigationLink(destination: AddInfoScreen(noticationList: $cardModels), isActive: $goToAddPlantScreen, label: {EmptyView()}))
        .navigationBarBackButtonHidden(true)
    }
    
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(Defaults())
    }
}

struct NotificationAdapter {
    
    var id: UUID? = UUID()
    var isResolve: Bool? = false
    var nextTimeToAlert: String? = ""
    var timeToAlert: String? = ""
    var typeToAlert: String? = ""
    var notificationPlant: PlantAdapter? = PlantAdapter()
    
    init() {}
    
    init(notification: Notification) {
        self.id = notification.id
        self.isResolve = notification.isResolve
        self.nextTimeToAlert = notification.nextTimeToAlert
        self.timeToAlert = notification.timeToAlert
        self.typeToAlert = notification.typeToAlert
        self.notificationPlant = PlantAdapter(category: notification.notificationPlant?.category,id: notification.notificationPlant?.id,name: notification.notificationPlant?.name)
    }
}

struct PlantAdapter {
    var category: String? = ""
    var id: UUID? = UUID()
    var information: String? = ""
    var name: String? = "Jninho"
    var wateringFrequency: String? = ""
    var plantNotification: [NotificationAdapter]? = []
    var plantHortcultImages: [HortCultImages]? = []
    
}
