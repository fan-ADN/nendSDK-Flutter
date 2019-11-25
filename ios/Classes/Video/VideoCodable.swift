//
//  VideoCodable.swift
//  nend_plugin
//
//

import Foundation

struct VideoCodable: Codable {
    let mappingId: String
    var mediationName: String?
    var userId: String?
    var userFeature: UserFeature?
    var locationEnabled: Bool?
    var muteStartPlaying: Bool?
}
