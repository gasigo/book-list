@testable import BookList

final class ConfigurationProviderSpy: ConfigurationProvider, Spy {
	var getConfigurationCounter = 0
	var getConfigurationResponse: NetworkConfiguration?
	var getConfigurationError: Error?

	func getConfiguration() throws -> NetworkConfiguration {
		getConfigurationCounter += 1

		if let error = getConfigurationError {
			throw error
		}

		return getConfigurationResponse!
	}

	func reset() {
		getConfigurationCounter = 0
		getConfigurationResponse = nil
		getConfigurationError = nil
	}
}
