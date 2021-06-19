#!/usr/bin/swift

import Foundation

typealias Diagram = [String: [String]]

struct Node {
	let identifier: String
	let parent: String?
}

extension Array {
	func interspersed(separator: Element) -> [Element] {
		Array(map { [$0] }.joined(separator: [separator]))
	}
}

final class GraphvizFormatter {
	private let spacing = "  "

	func format(diagram: Diagram) -> String {
		let nodes = diagram.map { formatEntity(with: $0.key) }
		let relations = diagram
			.map { parent, children in
				children.map { formatRelation(between: parent, and: $0) }
			}
			.flatMap { $0 }

		return formatFile(nodes: nodes, relations: relations)
	}

	private func formatEntity(with name: String) -> String {
		spacing + "\(name) [shape=box]"
	}

	private func formatRelation(between parent: String, and child: String) -> String {
		return spacing + "\(parent) -> \(child)"
	}

	private func formatFile(nodes: [String], relations: [String]) -> String {
		(["digraph {"] + nodes + relations + ["}"])
			.interspersed(separator: "\n")
			.reduce("", +)
	}
}

final class DiagramParser {
	let treePath = FileManager.default.currentDirectoryPath + "/BookList/Composition"
	let nodeNameRegex = "^.*\\s([a-zA-Z]+)ComponentImpl:.*$"
	let parentNameRegex = "^.+\\s([a-zA-Z]+)ComponentImpl$"

	func getNodeName(from file: String) -> String? {
		let lines = file.components(separatedBy: "\n")

		for line in lines {
			guard let name = matches(for: nodeNameRegex, in: line).first else { continue }

			return name
		}

		return nil
	}

	func getParentName(from file: String) -> String? {
		let lines = file.components(separatedBy: "\n")

		for line in lines {
			guard let name = matches(for: parentNameRegex, in: line).first else { continue }

			return name
		}

		return nil
	}

	func matches(for regex: String, in text: String) -> [String] {
		do {
			let textRange = NSRange(text.startIndex..<text.endIndex, in: text)
			let captureRegex = try NSRegularExpression(pattern: regex)
			let matches = captureRegex.matches(in: text, options: [], range: textRange)

			guard let match = matches.first else {
				return []
			}

			var groups: [String] = []

			for rangeIndex in 0..<match.numberOfRanges {
				let matchRange = match.range(at: rangeIndex)

				if matchRange == textRange { continue }

				if let substringRange = Range(matchRange, in: text) {
					let capture = String(text[substringRange])
					groups.append(capture)
				}
			}

			return groups
		} catch {
			print("invalid regex \(error)")
			return []
		}
	}

	func getNodeFiles() -> [String]? {
		var files: [URL] = []

		if let enumerator = FileManager.default.enumerator(
			at: URL(fileURLWithPath: treePath),
			includingPropertiesForKeys: [.isRegularFileKey],
			options: [.skipsHiddenFiles, .skipsPackageDescendants]
		) {
			for case let fileURL as URL in enumerator {
				do {
					let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
					if fileAttributes.isRegularFile! {
						files.append(fileURL)
					}
				} catch {
					print(error)
				}
			}
		}

		var encoding = String.Encoding(rawValue: 0)

		return files.compactMap {
			try? String(contentsOf: $0, usedEncoding: &encoding)
		}
	}

	func generateDiagram() -> Diagram {
		guard let nodeFiles = getNodeFiles() else { return [:] }

		var diagramTable: [String: [String]] = [:]

		let nodes: [Node] = nodeFiles.compactMap { file in
			guard let identifier = getNodeName(from: file) else { return nil }
			return Node(identifier: identifier, parent: getParentName(from: file))
		}

		for node in nodes {
			if diagramTable[node.identifier] == nil {
				diagramTable[node.identifier] = []
			}

			guard let parentIdentifier = node.parent else {
				continue
			}

			if let parentChildren = diagramTable[parentIdentifier] {
				diagramTable[parentIdentifier] = parentChildren + [node.identifier]
			} else {
				diagramTable[parentIdentifier] = [node.identifier]
			}
		}

		return diagramTable
	}
}

func exportTree() {
	let formatter = GraphvizFormatter()
	let parser = DiagramParser()

	let diagram = parser.generateDiagram()

	print(formatter.format(diagram: diagram))
}

exportTree()
