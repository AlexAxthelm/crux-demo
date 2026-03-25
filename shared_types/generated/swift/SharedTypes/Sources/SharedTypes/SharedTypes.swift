import Serde


indirect public enum Effect: Hashable {
    case render(SharedTypes.RenderOperation)

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        switch self {
        case .render(let x):
            try serializer.serialize_variant_index(value: 0)
            try x.serialize(serializer: serializer)
        }
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> Effect {
        let index = try deserializer.deserialize_variant_index()
        try deserializer.increase_container_depth()
        switch index {
        case 0:
            let x = try SharedTypes.RenderOperation.deserialize(deserializer: deserializer)
            try deserializer.decrease_container_depth()
            return .render(x)
        default: throw DeserializationError.invalidInput(issue: "Unknown variant index for Effect: \(index)")
        }
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> Effect {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

indirect public enum Event: Hashable {
    case navigateToSettings
    case navigateToLibrary

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        switch self {
        case .navigateToSettings:
            try serializer.serialize_variant_index(value: 0)
        case .navigateToLibrary:
            try serializer.serialize_variant_index(value: 1)
        }
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> Event {
        let index = try deserializer.deserialize_variant_index()
        try deserializer.increase_container_depth()
        switch index {
        case 0:
            try deserializer.decrease_container_depth()
            return .navigateToSettings
        case 1:
            try deserializer.decrease_container_depth()
            return .navigateToLibrary
        default: throw DeserializationError.invalidInput(issue: "Unknown variant index for Event: \(index)")
        }
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> Event {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

public struct FeedViewModel: Hashable {
    @Indirect public var id: String
    @Indirect public var title: String
    @Indirect public var episode_count: UInt32

    public init(id: String, title: String, episode_count: UInt32) {
        self.id = id
        self.title = title
        self.episode_count = episode_count
    }

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        try serializer.serialize_str(value: self.id)
        try serializer.serialize_str(value: self.title)
        try serializer.serialize_u32(value: self.episode_count)
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> FeedViewModel {
        try deserializer.increase_container_depth()
        let id = try deserializer.deserialize_str()
        let title = try deserializer.deserialize_str()
        let episode_count = try deserializer.deserialize_u32()
        try deserializer.decrease_container_depth()
        return FeedViewModel.init(id: id, title: title, episode_count: episode_count)
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> FeedViewModel {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

public struct LibraryViewModel: Hashable {
    @Indirect public var feeds: [SharedTypes.FeedViewModel]

    public init(feeds: [SharedTypes.FeedViewModel]) {
        self.feeds = feeds
    }

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        try serialize_vector_FeedViewModel(value: self.feeds, serializer: serializer)
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> LibraryViewModel {
        try deserializer.increase_container_depth()
        let feeds = try deserialize_vector_FeedViewModel(deserializer: deserializer)
        try deserializer.decrease_container_depth()
        return LibraryViewModel.init(feeds: feeds)
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> LibraryViewModel {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

public struct RenderOperation: Hashable {

    public init() {
    }

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> RenderOperation {
        try deserializer.increase_container_depth()
        try deserializer.decrease_container_depth()
        return RenderOperation.init()
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> RenderOperation {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

public struct Request: Hashable {
    @Indirect public var id: UInt32
    @Indirect public var effect: SharedTypes.Effect

    public init(id: UInt32, effect: SharedTypes.Effect) {
        self.id = id
        self.effect = effect
    }

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        try serializer.serialize_u32(value: self.id)
        try self.effect.serialize(serializer: serializer)
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> Request {
        try deserializer.increase_container_depth()
        let id = try deserializer.deserialize_u32()
        let effect = try SharedTypes.Effect.deserialize(deserializer: deserializer)
        try deserializer.decrease_container_depth()
        return Request.init(id: id, effect: effect)
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> Request {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

indirect public enum ScreenViewModel: Hashable {
    case library(SharedTypes.LibraryViewModel)
    case settings

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        switch self {
        case .library(let x):
            try serializer.serialize_variant_index(value: 0)
            try x.serialize(serializer: serializer)
        case .settings:
            try serializer.serialize_variant_index(value: 1)
        }
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> ScreenViewModel {
        let index = try deserializer.deserialize_variant_index()
        try deserializer.increase_container_depth()
        switch index {
        case 0:
            let x = try SharedTypes.LibraryViewModel.deserialize(deserializer: deserializer)
            try deserializer.decrease_container_depth()
            return .library(x)
        case 1:
            try deserializer.decrease_container_depth()
            return .settings
        default: throw DeserializationError.invalidInput(issue: "Unknown variant index for ScreenViewModel: \(index)")
        }
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> ScreenViewModel {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

public struct ViewModel: Hashable {
    @Indirect public var current_screen: SharedTypes.ScreenViewModel

    public init(current_screen: SharedTypes.ScreenViewModel) {
        self.current_screen = current_screen
    }

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        try self.current_screen.serialize(serializer: serializer)
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> ViewModel {
        try deserializer.increase_container_depth()
        let current_screen = try SharedTypes.ScreenViewModel.deserialize(deserializer: deserializer)
        try deserializer.decrease_container_depth()
        return ViewModel.init(current_screen: current_screen)
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> ViewModel {
        let deserializer = BincodeDeserializer.init(input: input);
        let obj = try deserialize(deserializer: deserializer)
        if deserializer.get_buffer_offset() < input.count {
            throw DeserializationError.invalidInput(issue: "Some input bytes were not read")
        }
        return obj
    }
}

func serialize_vector_FeedViewModel<S: Serializer>(value: [SharedTypes.FeedViewModel], serializer: S) throws {
    try serializer.serialize_len(value: value.count)
    for item in value {
        try item.serialize(serializer: serializer)
    }
}

func deserialize_vector_FeedViewModel<D: Deserializer>(deserializer: D) throws -> [SharedTypes.FeedViewModel] {
    let length = try deserializer.deserialize_len()
    var obj : [SharedTypes.FeedViewModel] = []
    for _ in 0..<length {
        obj.append(try SharedTypes.FeedViewModel.deserialize(deserializer: deserializer))
    }
    return obj
}

