//
//  JsonLoader.swift
//  Bitemap
//
//  Created by Lin Dan Christiano on 27/03/25.
//

// JsonLoader.swift - Update or create this file in the Services directory

import Foundation

struct JsonLoader {
    static func load<T: Decodable>(_ type: T.Type, from filename: String) -> T? {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
