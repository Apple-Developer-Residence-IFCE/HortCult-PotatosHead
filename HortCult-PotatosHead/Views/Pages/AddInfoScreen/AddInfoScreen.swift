
import SwiftUI

struct AddInfoScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isSelectedTab = 0
    @State private var isNextScreenActive = false
    @State var nameText: String = ""
    @State var descriptionText: String = ""
    @State var category: Category?
    @State var frequency: Frequency?
    @State var isDisabled: Bool = false
    @State var selectedPhotosData: [Data] = []
    @Binding var noticationList: [CardViewModel]
    @State private var presentAlert = false
    @State private var addAlert = false
    @EnvironmentObject var defaults: Defaults
    var plant: Plant?
    @State var isEdit: Bool = false
    var body: some View {
        ZStack {
            VStack {
                CustomNavBar(hiddenDismissButton: false)
                ScrollView {
                    HStack {
                        Text(isEdit ? "Editar Informações" : "Adicionar Vegetal")
                            .font(.custom("Satoshi-Bold", size: 28))
                            .foregroundColor(Color("MainColor"))
                        Spacer()
                    }
                    .padding()
                    TextScreen(text: $nameText, description: $descriptionText, isEdit: false)
                        .padding(.bottom, 20)
                    CategoryDropDownView(selectedOption: $category)
                        .padding(.bottom, 20)
                    FrequencyDropDownView(selectedOption: $frequency)
                        .padding(.bottom, 20)
                    ImagePickerComponentView(selectedPhotosData: $selectedPhotosData)
                        .padding(.bottom, 110)
                }
            }.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                if !isEdit {
                    if !((frequency != nil) && (category != nil) && !nameText.isEmpty && !descriptionText.isEmpty) {
                        AddButton(isDisabled: true) {}
                    } else {
                        AddButton(isDisabled: false) {
                            guard let frequencia = frequency?.rawValue else {return}
                            guard let categoria = category?.rawValue else {return}
                            guard let neewPlant  = Service.plant.createPlant(name: nameText,
                                                                             category: categoria,
                                                                             information: descriptionText,
                                                                             wateringFrequency: frequencia)
                            else {return}
                            selectedPhotosData.forEach { data in
                                guard let newImage = Service.image.createImage(plantImage: data) else {return}
                                Service.plant.addImageToPlant(plant: neewPlant, plantImage: newImage)
                            }
                            addAlert = true
                            guard let newNotification = Service.notification.createNotification(
                                nextTimeToAlert: Service.notification.calculateNextWatering(
                                    wateringFrequency: frequency!),
                                timeToAlert: "",
                                typeToAlert: NotificationType.watering.rawValue) else {return}
                            Service.plant.addNotificationToPlant(plant: neewPlant, notification: newNotification)
                            let notificationDisplayed = HomeViewModel.notificationsTextsToDisplay(
                                notification: newNotification
                            )
                            if AddInfoScreenViewModel.verifyNotificationToday(
                                date: newNotification.next_time_to_alert ?? "") {
                                noticationList.append(CardViewModel(
                                    id: notificationDisplayed.id,
                                    title: notificationDisplayed.title,
                                    content: notificationDisplayed.description,
                                    icon: notificationDisplayed.icon,
                                    cardColor: notificationDisplayed.cardColor,
                                    backgroudCardColor: notificationDisplayed.backgroudCardColor,
                                    textColor: notificationDisplayed.textColor))
                            }
                        }
                    }
                } else {
                    if !((frequency != nil) && (category != nil) && !nameText.isEmpty && !descriptionText.isEmpty) {
                        EditButton(isDisabled: true) {}
                    } else {
                        EditButton(isDisabled: false) {
                            if !isEdit {
                                guard let frequencia = frequency?.rawValue else {return}
                                guard let categoria = category?.rawValue else {return}
                                guard Service.plant.createPlant(name: nameText,
                                                                category: categoria,
                                                                information: descriptionText,
                                                                wateringFrequency: frequencia) != nil else {return}
                                self.presentationMode.wrappedValue.dismiss()
                            } else {
                                guard let frequencia = frequency?.rawValue else {return}
                                guard let categoria = category?.rawValue else {return}
                                guard let plant = plant else {return}
                                Service.plant.updatePlant(plant: plant,
                                                          name: nameText,
                                                          category: categoria,
                                                          information: descriptionText,
                                                          wateringFrequency: frequencia)
                                plant.plant_hortcult_images?.allObjects.forEach({ image in
                                    guard let imagePlant =
                                            image as? HortCultImages else {return}
                                    Service.plant.removeImageToPlant(
                                        plant: plant,
                                        plantImage: imagePlant)
                                })
                                selectedPhotosData.forEach { data in
                                    guard let newImage = Service.image.createImage(plantImage: data) else {return}
                                    Service.plant.addImageToPlant(plant: plant, plantImage: newImage)
                                }
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }
                }
            }
            if presentAlert {
                Color.black.opacity(0.1)
                    .edgesIgnoringSafeArea(.all)
                    .zIndex(0)
            }
            if addAlert {
                AlertCustomView(alerta: .add, plant: Service.plant.plants.last ?? Plant())
                    .zIndex(1)
                    .onAppear {
                        presentAlert = true
                    }
            }
        }
        .padding(.bottom, 60)
        .edgesIgnoringSafeArea(.all)
        .navigationBarBackButtonHidden(true)
    }
}
