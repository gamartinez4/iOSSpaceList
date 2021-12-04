

import SwiftUI

extension String{
    func load() -> UIImage{
        do{
            guard let url = URL(string: self) else {return UIImage(imageLiteralResourceName: "no_image")}
            let data:Data = try Data(contentsOf: url)
            return UIImage(data:data) ?? UIImage()
        }
        catch{}
        return UIImage()
    }
        
}



struct ContentView: View {
    
    
    @State var listModelUI:[ListModel] = []
    @State var visibleImage = false
    
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            GeometryReader{g in
                VStack{
                    NavigationView{
                        List(listModelUI,id: \.id){model in
                            NavigationLink(destination: DetailView(selectedItem: model)){
                                    Image(uiImage: model.url.load()).resizable()
                                        .frame(width: 50.0, height: 50.0)
                                }
                        }
                    }.onAppear(perform: loadData)
                
                    Button(visibleImage ? "Ocultar imagen del dia" : "Mostrar imagen del dia"){
                        withAnimation{
                            visibleImage.toggle()
                        }
                    }
                }
                if visibleImage{
                    VStack{
                        Image(uiImage: listModelUI[0].url.load()).resizable()
                            .frame(width: g.size.width*0.7, height: g.size.width*0.7)
                    
                    }
                    .frame(width: g.size.width*0.7, height: g.size.width*0.7,alignment: .center).background(Color.black).padding( 50)
                        .shadow(radius: 10).transition(.scale)
                        //.opacity(isHidden ? 0 : 1)
                }
                
            }
        }
    }
    
    
    func loadData(){
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        var past:String = ""
        if let date = Calendar.current.date(byAdding: .day, value: -8, to: Date()) {
            past = formatter.string(from: date)
        }else {return}
        
        let today = formatter.string(from: Date())
    
        let url = "https://api.nasa.gov/planetary/apod?start_date=\(past)&end_date=\(today)&api_key=42gEVUirTPPDopMbE9ZGpxPJi4lMdNyTm0gBxghg"
        print(url)
        guard let url = URL(string: url) else {return}
    
            URLSession.shared.dataTask(with: url){ data, response, error in
                guard let data = data else {return}
                do{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [Any]
                    
                    for i in json!{
                        
                        let model = i as? [String:String]
                        let listModel = ListModel()
                        listModel.url = model?["hdurl"] ?? ""
                        listModel.date = (model?["date"])!
                        listModel.explanation = (model?["explanation"])!
                        listModel.title = (model?["title"])!
                        listModelUI.append(listModel)
                    }
                   // print(listModelUI[1].url)
                }catch{
                }
                
        }.resume()
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


