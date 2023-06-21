
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
    var plant: Plant?
    @ObservedObject var plantViewModel: PlantViewModel
    var uuid: (UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8, UInt8)?
    @State var isEdit: Bool = false
    var header: some View {
        ZStack{
            Image("Topbar")
            HStack{
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                } ) {
                    Image("leftArrow")
                }
                .padding(.leading, 12)
                Spacer()
            }
        }
    }
    var body: some View {
        NavigationView {
            VStack{
                ZStack{
                    ScrollView{
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
                        ImagePickerComponentView()
                    }
                    VStack{
                        Spacer()
                        if (!((frequency != nil) && (category != nil) && !nameText.isEmpty && !descriptionText.isEmpty)){
                            AddButton(isDisabled: true, isEdit: isEdit){}
                        }
                        else {
                            AddButton(isDisabled: false, isEdit: true ){
                                if(!isEdit){
                                    guard let frequencia = frequency?.rawValue else {return}
                                    guard let categoria = category?.rawValue else {return}
                                    plantViewModel.createPlant(name: nameText, category: categoria , information: descriptionText, watering_frequency: frequencia)
                                } else {
                                    guard let frequencia = frequency?.rawValue else {return}
                                    guard let categoria = category?.rawValue else {return}
                                    plantViewModel.updatePlant(plant: plant!, name: nameText, category: categoria , information: descriptionText, watering_frequency: frequencia)
                                }
                                
                            }
                        }
                        
//                        Button("CLick"){
//                            print(plantViewModel.plants)
//                        }
                        
                       // Text("\(plantViewModel.plants.count)")
                    }
                    .padding(.bottom, 60)
                }
            }
        }.navigationTitle("")
            .navigationBarBackButtonHidden()
            
     
    }
}

struct AddInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        AddInfoScreen(plantViewModel: PlantViewModel(), isEdit: false)
    }
}

