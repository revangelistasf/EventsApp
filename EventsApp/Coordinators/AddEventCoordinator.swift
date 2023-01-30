import UIKit

final class AddEventCoordinator: Coordinator {
    private(set) var childCoordinators: [Coordinator] = []
    private let navigationController: UINavigationController
    private var modalNavigationController: UINavigationController?
    private var completion: (UIImage) -> Void = { _ in }
    var parentCoordinator: EventListCoordinator?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        self.modalNavigationController = UINavigationController()
        let addEventViewController: AddEventViewController = .instantiate()
        modalNavigationController?.setViewControllers([addEventViewController], animated: false)
        let addEventViewModel = AddEventViewModel(cellBuilder: EventsCellBuilder())
        addEventViewModel.coordinator = self
        addEventViewController.viewModel = addEventViewModel
        if let modalNavigationController = self.modalNavigationController {
            navigationController.present(modalNavigationController, animated: true)
        }
    }
    
    func didFinish() {
        parentCoordinator?.childDidFinish(self)
    }
    
    func didFinishSaveEvent() {
        parentCoordinator?.onUpdateEvent()
        modalNavigationController?.dismiss(animated: true)
    }
    
    func showImagePicker(completion: @escaping (UIImage) -> Void) {
        guard let modalNavigationController = self.modalNavigationController else { return }
        self.completion = completion
        let imagePickerCoordinator = ImagePickerCoordinator(navigationController: modalNavigationController)
        imagePickerCoordinator.onFinishPicking = { image in
            self.completion(image)
            self.modalNavigationController?.dismiss(animated: true)
        }
        imagePickerCoordinator.parentCoordinator = self
        childCoordinators.append(imagePickerCoordinator)
        imagePickerCoordinator.start()
    }
    
    func didFinishPicking(_ image: UIImage) {
        completion(image)
        modalNavigationController?.dismiss(animated: true)
    }
    
    func childDidFinish(_ childCoordinator: Coordinator) {
        if let index = childCoordinators.firstIndex(where: { coordinator in
            return childCoordinator === coordinator
        }) {
            self.childCoordinators.remove(at: index)
        }
    }
}
