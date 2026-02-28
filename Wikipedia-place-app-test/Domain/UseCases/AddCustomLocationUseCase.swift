//
//  AddCustomLocationUseCase.swift
//  Wikipedia-place-app-test
//
//  Created by Alessandro Minopoli on 28/02/26.
//

struct AddCustomLocationUseCase: AddCustomLocationUseCaseProtocol {
    
    let repository: LocationRepositoryProtocol
    
    init(repository: LocationRepositoryProtocol) {
        self.repository = repository
    }
    
    func addCustomLocation(_ location: Location) async {
        await repository.addCustomLocation(location)
    }
}
