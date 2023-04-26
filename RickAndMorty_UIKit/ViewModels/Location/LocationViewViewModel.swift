//
//  LocationViewViewModel.swift
//  RickAndMorty_UIKit
//
//  Created by Sonic on 25/4/23.
//

import Foundation

protocol LocationViewViewModelDelegate: AnyObject {
    
    func didFetchInitialLocations()
}

final class LocationViewViewModel {
    
    weak var delegate: LocationViewViewModelDelegate?
    private var locations = [Location]() {
        didSet {
            for location in locations {
                let cellViewModel = LocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(where: { $0.id == location.id }) {
                    cellViewModels.append(cellViewModel)                    
                }
            }
        }
    }
    public private(set) var cellViewModels = [LocationTableViewCellViewModel]()
    private var hasMoreResults: Bool {
        return false
    }
    private var apiInfo: GetAllLocationsResponse.Info?
    
    public func locations(at index: Int) -> Location? {
        guard index < locations.count, index >= 0 else { return nil }
        
        return self.locations[index]
    }
    
    public func fetchLocations() {
        
        RMService.shared.execute(.listLocationsRequest, expecting: GetAllLocationsResponse.self) { [weak self] result in
            
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let failure):
                print(String(describing: failure))
            }
        }
    }
    
}
