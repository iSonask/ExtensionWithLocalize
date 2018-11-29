//
//  UserDefaults.swift
//  AK
//
//  Created by SHANI SHAH on 29/11/18.
//

import Foundation


private let UserDefaultsLockPrefix = "LOCK_"
public extension UserDefaults {
    public class func isLocked(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: getLockKey(key)) != nil
    }
    
    public class func lock(key: String) {
        UserDefaults.standard.set(true, forKey: getLockKey(key))
        UserDefaults.standard.synchronize()
    }
    
    private class func getLockKey(_ key: String) -> String {
        return "\(UserDefaultsLockPrefix)\(key.uppercased())"
    }
    
    public func bool(forKey defaultName: String, defaultValue: Bool) -> Bool {
        if object(forKey: defaultName) == nil {
            return defaultValue
        }
        return bool(forKey: defaultName)
    }
    
    public func saveJson<T: Encodable>(object: T, for key: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: key)
            synchronize()
        } catch {
            print(error)
        }
    }
    
    public func loadJson<T: Decodable>(_ type: T.Type, key: String) -> T? {
        if let data = data(forKey: key) {
            let decoder = JSONDecoder()
            do {
                let user = try decoder.decode(type, from: data)
                return user
            } catch {
                
            }
        }
        return nil
    }
}
