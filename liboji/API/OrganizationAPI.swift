
import Foundation
import Macaroons

private struct OrgLocations: Decodable {
    public var organizationLocations: [OrgLocation]
}

public struct OrgLocation: Equatable, Decodable {
    public let id: String
    public let name: String

    public static func == (lhs: OrgLocation, rhs: OrgLocation) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name
    }
}

private let OrgLocationsQuery = """
query OrganizationLocations() {
    organizationLocations {
        name
        id
    }
}
"""

 
public func loadOrganizationLocations(
    apiHost: URL,
    identoji: Macaroon,
    completion: @escaping (RequestRes<[OrgLocation]>) -> Void)
{
    let input: [String: String] = [:]

    gqlQuery(
        apiHost: apiHost,
        identoji: identoji,
        operation: "OrganizationLocations",
        query: OrgLocationsQuery,
        variables: input
    ) { (res: RequestRes<OrgLocations>) -> Void in 
        completion(res.map { $0.organizationLocations }) }
}

