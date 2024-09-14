

import Foundation
class HomePageViewModel {
    
    var items : [HomeCellModel] = [
        HomeCellModel(cellName: "Tarla Ekle", cellImage: "bugday"),
        HomeCellModel(cellName: "Kredi Talebi", cellImage:  "kredi"),
        HomeCellModel(cellName: "Kampanyalar", cellImage:  "kampanya"),
        HomeCellModel(cellName: "Şeker Mobil", cellImage:  "sekermobil"),
        HomeCellModel(cellName: "Bize Ulaşın", cellImage:  "iletisim")
    ]
    
    func getItem (at index: Int) -> HomeCellModel{
        return items[index]
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
    
    
}
