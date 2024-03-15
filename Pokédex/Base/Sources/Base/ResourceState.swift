import Foundation

public enum ResourceState<T> {
    case loading
    case loaded(T)
    case error(Error)
    
    public var value: T? {
        switch self {
        case let .loaded(resource):
            return resource
        default:
            return nil
        }
    }
    
    public var isLoading: Bool {
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }
    
    public var isLoaded: Bool {
        switch self {
        case .loaded:
            return true
        default:
            return false
        }
    }
    
    public var isError: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
}
