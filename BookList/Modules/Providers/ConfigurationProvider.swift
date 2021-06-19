import Foundation
import ToggleFoundation

protocol ConfigurationProvider {
	func getConfiguration() throws -> NetworkConfiguration
}

final class ConfigurationProviderImpl: ConfigurationProvider {
	func getConfiguration() throws -> NetworkConfiguration {
		guard
			let path = Bundle.main.path(forResource: "Configuration", ofType: "plist"),
			let xml = FileManager.default.contents(atPath: path)
		else {
			throw CustomError.unableToFindFile
		}

		return try PropertyListDecoder().decode(NetworkConfiguration.self, from: xml)
	}
}

private extension CustomError {
	static var unableToFindFile: CustomError {
		CustomError(message: "Couldn't find the configuration file")
	}
}
