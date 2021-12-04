//
//  DetailView.swift
//  ejercicio
//
//  Created by Rubber Pachon Medina on 24/11/21.
//

import SwiftUI

struct DetailView: View {
    
    var selectedItem:ListModel?
    
    var body: some View {
        ScrollView{
        VStack(spacing: 10){
            Image(uiImage: selectedItem!.url.load()).resizable()
                .frame(width: 90.0, height: 90.0)
                .cornerRadius(3)
            
            
            Text(selectedItem?.title ?? "Sin información")
                .padding(20)
                .multilineTextAlignment(.center)
                .font(Font.body.bold())
                
            
            Text(selectedItem?.explanation ?? "Sin información").multilineTextAlignment(.center)
                .font(.custom("FONT_NAME", size: 13)).padding(10)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(selectedItem: nil)
    }
}
