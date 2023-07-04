import SwiftUI
import Foundation

struct NotificationDisplayed {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let cardColor: String
    let backgroudCardColor: String
    let textColor: String
    let titleFont: String
    let contentFont: String
}

struct HomeViewModel {
    static func notificationsTextsToDisplay (notification: Notification) -> NotificationDisplayed{
        var notificationDisplayed: NotificationDisplayed
        guard let notificationType =  notification.type_to_alert else {return NotificationDisplayed(id: UUID() ,title: "", description: "", icon: "", cardColor: "", backgroudCardColor: "", textColor: "", titleFont: "", contentFont: "")}
        switch NotificationType(rawValue: notificationType){
        case .watering:
            notificationDisplayed = NotificationDisplayed(id: notification.id ?? UUID() ,title: "\(notification.notification_plant?.name ?? "") está com sede!", description: "Dê água para a sua plantinha.", icon: "Water-Orange", cardColor: "lembreteIcon", backgroudCardColor: "AlertCardColor", textColor: "TextColor", titleFont: "Satoshi-Bold", contentFont: "Satoshi-Regular")
            
            
        case .none:
            notificationDisplayed = NotificationDisplayed(id: UUID() ,title: "", description: "", icon: "", cardColor: "", backgroudCardColor: "", textColor: "", titleFont: "", contentFont: "")
        }
        return notificationDisplayed
    }
    
    static func checkCardNotification(notificationID: UUID, notificationViewModel: NotificationViewModel, cards: [CardViewModel], plantViewModel: PlantViewModel) -> [CardViewModel] {
        guard let notificationSelected = notificationViewModel.notifications.filter({ Notification in
            return Notification.id == notificationID
        }).first else {return []}
        
        guard let plant = notificationSelected.notification_plant else {return []}
        
        notificationViewModel.updateNotification(notification: notificationSelected, next_time_to_alert: notificationSelected.next_time_to_alert ?? "", time_to_alert: notificationSelected.time_to_alert ?? "", type_to_alert: notificationSelected.type_to_alert ?? "", is_resolve: true)
        
        guard let newNotification = notificationViewModel.createNotification(next_time_to_alert: notificationViewModel.calculateNextWatering(wateringFrequency: Frequency(rawValue: plant.watering_frequency!)!), time_to_alert: "", type_to_alert: NotificationType.watering.rawValue) else {return []}
     
        plantViewModel.addNotificationToPlant(plant: plant, notification: newNotification)
        
        return cards.filter { CardViewModel in
            return CardViewModel.id != notificationID
        }
    }
    
    
    
}


