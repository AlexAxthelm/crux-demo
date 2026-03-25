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

public struct EpisodeViewModel: Hashable {
    @Indirect public var id: String
    @Indirect public var title: String
    @Indirect public var duration: String

    public init(id: String, title: String, duration: String) {
        self.id = id
        self.title = title
        self.duration = duration
    }

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        try serializer.serialize_str(value: self.id)
        try serializer.serialize_str(value: self.title)
        try serializer.serialize_str(value: self.duration)
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> EpisodeViewModel {
        try deserializer.increase_container_depth()
        let id = try deserializer.deserialize_str()
        let title = try deserializer.deserialize_str()
        let duration = try deserializer.deserialize_str()
        try deserializer.decrease_container_depth()
        return EpisodeViewModel.init(id: id, title: title, duration: duration)
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> EpisodeViewModel {
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
    case navigateToFeedDetail(String)

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        switch self {
        case .navigateToSettings:
            try serializer.serialize_variant_index(value: 0)
        case .navigateToLibrary:
            try serializer.serialize_variant_index(value: 1)
        case .navigateToFeedDetail(let x):
            try serializer.serialize_variant_index(value: 2)
            try serializer.serialize_str(value: x)
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
        case 2:
            let x = try deserializer.deserialize_str()
            try deserializer.decrease_container_depth()
            return .navigateToFeedDetail(x)
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

public struct FeedDetailViewModel: Hashable {
    @Indirect public var id: String
    @Indirect public var title: String
    @Indirect public var episodes: [SharedTypes.EpisodeViewModel]

    public init(id: String, title: String, episodes: [SharedTypes.EpisodeViewModel]) {
        self.id = id
        self.title = title
        self.episodes = episodes
    }

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        try serializer.serialize_str(value: self.id)
        try serializer.serialize_str(value: self.title)
        try serialize_vector_EpisodeViewModel(value: self.episodes, serializer: serializer)
        try serializer.decrease_container_depth()
    }

    public func bincodeSerialize() throws -> [UInt8] {
        let serializer = BincodeSerializer.init();
        try self.serialize(serializer: serializer)
        return serializer.get_bytes()
    }

    public static func deserialize<D: Deserializer>(deserializer: D) throws -> FeedDetailViewModel {
        try deserializer.increase_container_depth()
        let id = try deserializer.deserialize_str()
        let title = try deserializer.deserialize_str()
        let episodes = try deserialize_vector_EpisodeViewModel(deserializer: deserializer)
        try deserializer.decrease_container_depth()
        return FeedDetailViewModel.init(id: id, title: title, episodes: episodes)
    }

    public static func bincodeDeserialize(input: [UInt8]) throws -> FeedDetailViewModel {
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
    case feedDetail(SharedTypes.FeedDetailViewModel)

    public func serialize<S: Serializer>(serializer: S) throws {
        try serializer.increase_container_depth()
        switch self {
        case .library(let x):
            try serializer.serialize_variant_index(value: 0)
            try x.serialize(serializer: serializer)
        case .settings:
            try serializer.serialize_variant_index(value: 1)
        case .feedDetail(let x):
            try serializer.serialize_variant_index(value: 2)
            try x.serialize(serializer: serializer)
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
        case 2:
            let x = try SharedTypes.FeedDetailViewModel.deserialize(deserializer: deserializer)
            try deserializer.decrease_container_depth()
            return .feedDetail(x)
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

func serialize_vector_EpisodeViewModel<S: Serializer>(value: [SharedTypes.EpisodeViewModel], serializer: S) throws {
    try serializer.serialize_len(value: value.count)
    for item in value {
        try item.serialize(serializer: serializer)
    }
}

func deserialize_vector_EpisodeViewModel<D: Deserializer>(deserializer: D) throws -> [SharedTypes.EpisodeViewModel] {
    let length = try deserializer.deserialize_len()
    var obj : [SharedTypes.EpisodeViewModel] = []
    for _ in 0..<length {
        obj.append(try SharedTypes.EpisodeViewModel.deserialize(deserializer: deserializer))
    }
    return obj
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

