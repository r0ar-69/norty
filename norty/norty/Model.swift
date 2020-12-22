import Foundation

struct Model {
    let className: String
    let classRoom: String
    
    static func createModels() -> [Model] {
        return [
            Model(className: "", classRoom: "")
        ]
    }
}
