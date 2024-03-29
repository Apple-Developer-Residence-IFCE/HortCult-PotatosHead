//
//  HeaderMenu.swift
//  HortCult-PotatosHead
//
//  Created by Joao Guilherme Araujo Canuto on 25/05/23.
//

import SwiftUI

struct HeaderMenu: View {
    @Binding var noticationList: [CardViewModel]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        
        VStack{
            HStack {
                Text("Minha Horta")
                    .font(.custom("Satoshi-Bold", size: 28))
                    .foregroundColor(Color("MainColor"))
                Spacer()
                
                NavigationLink(destination: AddInfoScreen(noticationList: $noticationList),
                               label: {
                    HStack{
                        Image(systemName: "plus")
                            .foregroundColor(Color("backgroundColor"))
                    }
                    .frame(width: 32,height: 32, alignment: .center)
                        .background(Color("MainColor"))
                        .clipShape(Circle())
                    
                })
                
                
            }
            ListHorta()
        }
        .padding()
    }
}

struct HeaderMenu_Previews: PreviewProvider {
    static var previews: some View {
        HeaderMenu(noticationList: .constant([]))
    }
}
