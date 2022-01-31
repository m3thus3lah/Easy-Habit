//
//  UserInputValidator.swift
//  Easy Habit
//
//  Created by BJIT on 24/1/22.
//

import Foundation

final class UserInputValidator {
    
    private init() {}
    
    
    static func invalidTitle(_ title: String) -> String? {
        if title.count > 80 {
            return "Title must not exceed 80 characters"
        }
        return nil
    }
    
    static func invalidDetails(_ details: String) -> String? {
        if details.count > 800 {
            return "Details must not exceed 800 characters"
        }
        return nil
    }
    
    static func invalidName(_ name: String) -> String?
    {
        if name.count > 30
        {
            return "Name must not exceed 50 characters"
        }
        if name.count < 1
        {
            return "Required"
        }
        if !isValidName(name)
        {
            return "Name must only contain letters"
        }
        return nil
    }
    
    private static func isValidName(_ name : String) -> Bool {
        let reqularExpression = #"^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return predicate.evaluate(with: name)
    }
    
    static func invalidDoB(_ dateOfBirth: String) -> String?
    {
        if !isValidDate(dateOfBirth)
        {
            return "Please insert a valid date"
        }
        return nil
    }
    
    private static func isValidDateFormat(_ dateOfBirth : String) -> Bool {
        
        let reqularExpression = #"([12]\d{3}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01]))"#
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        
        return predicate.evaluate(with: dateOfBirth)
        
    }
    
    private static func isValidDate(_ dateOfBirth: String) -> Bool {
        
        if isValidDateFormat(dateOfBirth) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if dateFormatter.date(from: dateOfBirth) == nil {
                return false
            }
            let birthYear = Int(dateOfBirth.prefix(while: { "0"..."9" ~= $0 }))!
            let currentYear = Int(Calendar.current.component(.year, from: Date()))
            if birthYear > currentYear {
                return false
            }
        }
        else {
            return false
        }
        
        return true
    }
    
    

}
