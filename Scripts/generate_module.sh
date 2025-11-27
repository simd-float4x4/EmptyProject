#!/bin/bash

# =============================================================================
# VIPER Module Generator Script
# SwiftUI + VIPER Architecture Template
# =============================================================================

set -e

# Color definitions
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
MODULES_DIR="$PROJECT_DIR/EmptyProject/Modules"

# Usage function
usage() {
    echo -e "${BLUE}Usage:${NC} $0 <ModuleName>"
    echo ""
    echo "Creates a new VIPER module with the following files:"
    echo "  - <ModuleName>Protocols.swift"
    echo "  - <ModuleName>Entity.swift"
    echo "  - <ModuleName>View.swift"
    echo "  - <ModuleName>Presenter.swift"
    echo "  - <ModuleName>Interactor.swift"
    echo "  - <ModuleName>Router.swift"
    echo ""
    echo -e "${YELLOW}Example:${NC} $0 Settings"
    exit 1
}

# Check if module name is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Module name is required${NC}"
    usage
fi

MODULE_NAME="$1"

# Validate module name (PascalCase, letters only)
if [[ ! "$MODULE_NAME" =~ ^[A-Z][a-zA-Z0-9]*$ ]]; then
    echo -e "${RED}Error: Module name must be in PascalCase (e.g., Settings, UserProfile)${NC}"
    exit 1
fi

MODULE_DIR="$MODULES_DIR/$MODULE_NAME"

# Check if module already exists
if [ -d "$MODULE_DIR" ]; then
    echo -e "${RED}Error: Module '$MODULE_NAME' already exists at $MODULE_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}Creating VIPER module: ${GREEN}$MODULE_NAME${NC}"
echo ""

# Create module directory
mkdir -p "$MODULE_DIR"

# =============================================================================
# Generate Protocols file
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}Protocols.swift" << EOF
//
//  ${MODULE_NAME}Protocols.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module Protocols
//

import UIKit

// MARK: - View Protocol
protocol ${MODULE_NAME}ViewProtocol: AnyObject {
    var presenter: ${MODULE_NAME}PresenterProtocol! { get set }
}

// MARK: - Presenter Protocol
protocol ${MODULE_NAME}PresenterProtocol: AnyObject, ObservableObject {
    var view: ${MODULE_NAME}ViewProtocol? { get set }
    var interactor: ${MODULE_NAME}InteractorInputProtocol! { get set }
    var router: ${MODULE_NAME}RouterProtocol! { get set }
    
    func viewDidLoad()
}

// MARK: - Interactor Protocol
protocol ${MODULE_NAME}InteractorInputProtocol: AnyObject {
    var presenter: ${MODULE_NAME}InteractorOutputProtocol? { get set }
    
    func fetchData()
}

protocol ${MODULE_NAME}InteractorOutputProtocol: AnyObject {
    func didFetchData(_ data: ${MODULE_NAME}Entity)
    func didFailFetchingData(with error: Error)
}

// MARK: - Router Protocol
protocol ${MODULE_NAME}RouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
}
EOF

# =============================================================================
# Generate Entity file
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}Entity.swift" << EOF
//
//  ${MODULE_NAME}Entity.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module Entity
//

import Foundation

struct ${MODULE_NAME}Entity: Identifiable, Equatable {
    let id: UUID
    let title: String
    let description: String
    
    init(id: UUID = UUID(), title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
EOF

# =============================================================================
# Generate View file
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}View.swift" << EOF
//
//  ${MODULE_NAME}View.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module View
//

import SwiftUI
import UIKit

// MARK: - SwiftUI View
struct ${MODULE_NAME}View: View {
    @ObservedObject var presenter: ${MODULE_NAME}Presenter
    
    var body: some View {
        VStack {
            if let data = presenter.data {
                Text(data.title)
                    .font(.largeTitle)
                Text(data.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            } else if presenter.isLoading {
                ProgressView()
            } else if let error = presenter.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationTitle("$MODULE_NAME")
        .onAppear {
            presenter.viewDidLoad()
        }
    }
}

// MARK: - UIHostingController
final class ${MODULE_NAME}ViewController: UIHostingController<${MODULE_NAME}View>, ${MODULE_NAME}ViewProtocol {
    var presenter: ${MODULE_NAME}PresenterProtocol!
    
    init(presenter: ${MODULE_NAME}Presenter) {
        self.presenter = presenter
        super.init(rootView: ${MODULE_NAME}View(presenter: presenter))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
EOF

# =============================================================================
# Generate Presenter file
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}Presenter.swift" << EOF
//
//  ${MODULE_NAME}Presenter.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module Presenter
//

import Foundation

final class ${MODULE_NAME}Presenter: ${MODULE_NAME}PresenterProtocol, ObservableObject {
    weak var view: ${MODULE_NAME}ViewProtocol?
    var interactor: ${MODULE_NAME}InteractorInputProtocol!
    var router: ${MODULE_NAME}RouterProtocol!
    
    @Published var data: ${MODULE_NAME}Entity?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    func viewDidLoad() {
        isLoading = true
        interactor.fetchData()
    }
}

// MARK: - Interactor Output
extension ${MODULE_NAME}Presenter: ${MODULE_NAME}InteractorOutputProtocol {
    func didFetchData(_ data: ${MODULE_NAME}Entity) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.data = data
        }
    }
    
    func didFailFetchingData(with error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading = false
            self?.errorMessage = error.localizedDescription
        }
    }
}
EOF

# =============================================================================
# Generate Interactor file
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}Interactor.swift" << EOF
//
//  ${MODULE_NAME}Interactor.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module Interactor
//

import Foundation

final class ${MODULE_NAME}Interactor: ${MODULE_NAME}InteractorInputProtocol {
    weak var presenter: ${MODULE_NAME}InteractorOutputProtocol?
    
    func fetchData() {
        // TODO: Implement data fetching logic
        let sampleData = ${MODULE_NAME}Entity(
            title: "$MODULE_NAME",
            description: "This is a sample $MODULE_NAME module."
        )
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.presenter?.didFetchData(sampleData)
        }
    }
}
EOF

# =============================================================================
# Generate Router file
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}Router.swift" << EOF
//
//  ${MODULE_NAME}Router.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module Router
//

import UIKit

final class ${MODULE_NAME}Router: ${MODULE_NAME}RouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let presenter = ${MODULE_NAME}Presenter()
        let interactor = ${MODULE_NAME}Interactor()
        let router = ${MODULE_NAME}Router()
        
        let view = ${MODULE_NAME}ViewController(presenter: presenter)
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
EOF

echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}Protocols.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}Entity.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}View.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}Presenter.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}Interactor.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}Router.swift"
echo ""
echo -e "${GREEN}Successfully created VIPER module: $MODULE_NAME${NC}"
echo -e "${YELLOW}Location: $MODULE_DIR${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Add the new files to your Xcode project"
echo "2. Implement the business logic in ${MODULE_NAME}Interactor.swift"
echo "3. Customize the UI in ${MODULE_NAME}View.swift"
echo "4. Add navigation in ${MODULE_NAME}Router.swift"

