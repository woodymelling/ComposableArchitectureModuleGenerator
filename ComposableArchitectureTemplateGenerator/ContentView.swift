//
//  ContentView.swift
//  ComposableArchitectureTemplateGenerator
//
//  Created by Woody on 2/9/22.
//

import SwiftUI

struct ContentView: View {
    @State var name: String = ""

    var body: some View {
        VStack {
            TextField("File Name", text: $name)
            ScrollView {
                VStack {

                    Text(productCode)
                        .textSelection(.enabled)

                    Divider()

                    Text(targetCode)
                        .textSelection(.enabled)

                    Divider()

                    Image(systemName: "folder.fill.badge.plus")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .onDrag {

                            if let itemProvider = NSItemProvider(contentsOf: createTempFolderWithFiles()) {
                                return itemProvider
                            } else {
                                return NSItemProvider()
                            }

                        }


                }
                .font(.system(.body, design: .monospaced))

            }
        }
    }

    func createTempFolderWithFiles() -> URL {


        func createFile(contents: String, fileName: String) {

            try! contents.data(using: .utf8)?.write(to: path.appendingPathComponent(fileName))
        }

        let path = FileManager.default.temporaryDirectory.appendingPathComponent(moduleName, isDirectory: true)

        try! FileManager.default.createDirectory(at: path, withIntermediateDirectories: true)

        createFile(contents: viewFileCode, fileName: viewFileName)

        createFile(contents: logicFileCode, fileName: domainFileName)


        return path
    }


    var fileName: String {
        name.isEmpty ? "FileName" : name
    }

    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return Date.now.formatted(
            .dateTime
                .day(.defaultDigits)
                .month(.defaultDigits)
                .year()
        )
    }

    var lowerCasedName: String {
        return fileName.prefix(1).lowercased() + fileName.dropFirst()
    }

    var upperCasedName: String {
        return fileName
    }

    var moduleName: String {
        "\(upperCasedName)Feature"
    }

    var productCode: String {
        """
        .library(name: "\(moduleName)", targets: ["\(moduleName)"]),
        """
    }

    var targetCode: String {
        """
        .target(
            name: "\(moduleName)",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Models", package: "FestivlLibrary")
            ]
        ),
        """
    }

    var viewFileName: String {
        "\(upperCasedName)View.swift"
    }

    var viewFileCode: String {
        """
        //
        //  \(viewFileName)
        //
        //
        //  Created by Woody on \(dateString).
        //

        import SwiftUI
        import ComposableArchitecture

        public struct \(upperCasedName)View: View {
            let store: Store<\(upperCasedName)State, \(upperCasedName)Action>

            public init(store: Store<\(upperCasedName)State, \(upperCasedName)Action>) {
                self.store = store
            }

            public var body: some View {
                WithViewStore(store) { viewStore in
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
            }
        }

        struct \(upperCasedName)View_Previews: PreviewProvider {
            static var previews: some View {
                ForEach(ColorScheme.allCases.reversed(), id: \\.self) {
                    \(upperCasedName)View(
                        store: .init(
                            initialState: .init(),
                            reducer: \(lowerCasedName)Reducer,
                            environment: .init()
                        )
                    )
                    .preferredColorScheme($0)
                }
            }
        }
        """
    }

    var domainFileName: String {
        "\(upperCasedName)Domain.swift"
    }

    var logicFileCode: String {
        
        """
        //
        // \(domainFileName)
        //
        //
        //  Created by Woody on \(dateString).
        //

        import ComposableArchitecture

        public struct \(upperCasedName)State: Equatable {
            public init() {}
        }

        public enum \(upperCasedName)Action {

        }

        public struct \(upperCasedName)Environment {
            public init() {}
        }

        public let \(lowerCasedName)Reducer = Reducer<\(upperCasedName)State, \(upperCasedName)Action, \(upperCasedName)Environment> { state, action, _ in
            return .none
        }
        """
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
