//
//  StorageManager.swift
//  HiLondon
//
//  Created by Minseok Kim on 05/09/2021.
//

import Foundation
import FirebaseStorage

final class StorageManager {
    
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    
    public typealias uploadPictureCompletion = (Result<String, Error>) -> Void
    
    public func uploadProfilePicture(with data: Data, fileName: String, completion: @escaping uploadPictureCompletion) {
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: { metadata, error in
            guard error == nil else {
                
                print("Failed to upload data to the storage.")
                completion(.failure(StorageErrors.failedToUpload))
                
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: { url, error in
                guard let url = url else {
                    print("Failed to get download URL.")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                let urlString = url.absoluteString
                print("Download URL Returned: \(urlString)")
                
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
    public func downloadURL(for path: String, completion: @escaping (Result<URL, Error>) -> Void) {
        let reference = storage.child(path)
        
        reference.downloadURL( completion: { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            
            completion(.success(url))
        })
    }
}
 
