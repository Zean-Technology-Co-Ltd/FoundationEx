//
//  URL+Extension.swift
//  qpyf
//
//  Created by zq on 2023/3/3.
//

import Foundation

extension URL {
   public func getSomeParameter(key: String) -> String? {
        let urlString = self.absoluteString
        guard let url = URLComponents(string: urlString) else { return nil }
        return url.queryItems?.first(where: { $0.name == key })?.value
    }
}
