//
//  UserPreferencesService.swift
//  Bitemap
//
//  Created by Jose Andreas Lie on 15/05/25.
//

import Foundation

class UserPreferencesService {
    private let userDefaultsKey = "userPreferences"
    
    func savePreferences(_ preferences: [UserPreferencesModel]) {
        if let encoded = try? JSONEncoder().encode(preferences) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func loadPreferences() -> [UserPreferencesModel]? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            return nil
        }
        
        return try? JSONDecoder().decode([UserPreferencesModel].self, from: data)
    }
}
