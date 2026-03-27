import Foundation
import SharedTypes

@MainActor
class Core: ObservableObject {
    @Published var view: ViewModel

    init() {
        guard let viewBytes = try? ViewModel.bincodeDeserialize(input: [UInt8](SimpleCounter.view())) else {
            fatalError("Failed to deserialize initial ViewModel from core")
        }
        self.view = viewBytes
    }

    func update(_ event: Event) {
        guard let serialized = try? event.bincodeSerialize() else {
            fatalError("Failed to serialize Event: \(event)")
        }
        let effects = [UInt8](processEvent(Data(serialized)))

        guard let requests: [Request] = try? .bincodeDeserialize(input: effects) else {
            fatalError("Failed to deserialize requests from core effects")
        }
        for request in requests {
            processEffect(request)
        }
    }

    func processEffect(_ request: Request) {
        switch request.effect {
        case .render:
            guard let updatedView = try? ViewModel.bincodeDeserialize(input: [UInt8](SimpleCounter.view())) else {
                fatalError("Failed to deserialize ViewModel during render")
            }
            view = updatedView
        }
    }
}
