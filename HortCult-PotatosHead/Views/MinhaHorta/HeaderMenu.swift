//
//  HeaderMenu.swift
//  HortCult-PotatosHead
//
//  Created by Joao Guilherme Araujo Canuto on 25/05/23.
//

import SwiftUI

struct HeaderMenu: View {
    var body: some View {
        VStack(spacing: 0){
            HStack {
                Text("Minha Horta")
                    .font(.system(size: 16))
                    .bold()
                    .foregroundColor(Color("MainColor"))
                Spacer()
                Button(action: {})
                {
                    Image(systemName: "plus")
                        .foregroundColor(Color("backgroundColor"))
                }
                .frame(width: 32,height: 32, alignment: .center)
                .background(Color("MainColor"))
                .clipShape(Circle())
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            .padding(.bottom,10)
            ListHorta()
        }
    }
}

struct HeaderMenu_Previews: PreviewProvider {
    static var previews: some View {
        HeaderMenu()
    }
}
