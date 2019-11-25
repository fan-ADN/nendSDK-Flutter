//
//  UserFeature.swift
//  nend_plugin
//
//

import Foundation

struct UserFeature: Codable {
    var gender: Int?
    var age: Int?
    var birthday: Birthday?

    var customIntegerParams: [String: Int]?
    var customStringParams: [String: String]?
    var customDoubleParams: [String: Double]?
    var customBooleanParams: [String: Bool]?
}
