//
//  Document.swift
//  Documents
//
//  Created by Grant Maloney on 8/26/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation

let dateFormatter = DateFormatter()

struct Document: Codable {
    let documentTitle: String
    let documentContent: String
    
    private enum CodingKeys: String, CodingKey {
        case documentTitle = "document_title"
        case documentContent = "document_content"
    }
}

struct DocumentLoaded {
    let documentTitle: String
    let documentContent: String
    let documentSize: String
    let dateModified: String
}

extension URL {
    var attributes: [FileAttributeKey : Any]? {
        do {
            return try FileManager.default.attributesOfItem(atPath: path)
        } catch let error as NSError {
            print("FileAttribute error: \(error)")
        }
        return nil
    }
    
    var fileSize: UInt64 {
        return attributes?[.size] as? UInt64 ?? UInt64(0)
    }
    
    var modificationDate: Date? {
        return attributes?[.modificationDate] as? Date
    }
}
