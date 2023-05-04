//
//  OMNDirectoryScanner.swift
//
//  Created by Omar M on 07/02/2019.
//  Copyright © 2019 All rights reserved.
//

import Cocoa

open class OMNDirectoryScanner: NSObject {
    fileprivate(set) var thumbnail: NSImage?
    fileprivate(set) var dirName: String
    fileprivate(set) var rootURL: URL
    
    @objc public var files: [URL] = []
    @objc public var subDirectories: [URL] = []
    
    @objc public init?(rootURL: URL) {
        self.rootURL = rootURL
        self.dirName = self.rootURL.lastPathComponent
        self.thumbnail = nil
        let imageSource = CGImageSourceCreateWithURL(rootURL.absoluteURL as CFURL, nil)
        if let imageSource = imageSource {
            guard CGImageSourceGetType(imageSource) != nil else { return }
            let thumbnailOptions = [
                String(kCGImageSourceCreateThumbnailFromImageIfAbsent): true,
                String(kCGImageSourceCreateThumbnailWithTransform): true,
                String(kCGImageSourceThumbnailMaxPixelSize): 160
            ] as [String : Any]
            if let thumbnailRef = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, thumbnailOptions as CFDictionary?) {
                self.thumbnail = NSImage(cgImage: thumbnailRef, size: NSSize.zero)
            }
        }
    }
    
    @objc public func scanFolder() -> Bool {
        self.files.removeAll()
        self.subDirectories.removeAll()
        
        let rootPath = self.rootURL.path
        let fileManager = FileManager.default
        guard let directoryEnumerator = fileManager.enumerator(atPath: rootPath) else {
            return false
        }
        
        while let fsNodeName = directoryEnumerator.nextObject() as? NSString {
            let fullPath = "\(rootPath)/\(fsNodeName)"
            var isDir: ObjCBool = false
            fileManager.fileExists(atPath: fullPath, isDirectory: &isDir)
            let url = URL(fileURLWithPath: fullPath)
            
            if !isDir.boolValue /*&& fsNodeName.pathExtension == "txt"*/ {
                self.files.append(url)
            }
            
            if isDir.boolValue {
                self.subDirectories.append(url)
            }
        }
        
        return true
    }
}


