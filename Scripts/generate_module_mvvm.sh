#!/bin/bash

# =============================================================================
# MVVM Module Generator Script
# SwiftUI + MVVM Architecture Template
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
    echo "Creates a new MVVM module with the following files:"
    echo "  - <ModuleName>Entity.swift (Model)"
    echo "  - <ModuleName>ViewModel.swift"
    echo "  - <ModuleName>View.swift"
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

echo -e "${BLUE}Creating MVVM module: ${GREEN}$MODULE_NAME${NC}"
echo ""

# Create module directory
mkdir -p "$MODULE_DIR"

# =============================================================================
# Generate Entity file (Model)
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}Entity.swift" << EOF
//
//  ${MODULE_NAME}Entity.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module Entity (Model)
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
# Generate ViewModel file
# =============================================================================
cat > "$MODULE_DIR/${MODULE_NAME}ViewModel.swift" << EOF
//
//  ${MODULE_NAME}ViewModel.swift
//  EmptyProject
//
//  ${MODULE_NAME} Module ViewModel
//

import Foundation
import Combine

final class ${MODULE_NAME}ViewModel: ViewModelProtocol, ObservableObject {
    @Published var data: ${MODULE_NAME}Entity?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    func onAppear() {
        fetchData()
    }
    
    func onDisappear() {
        cancellables.removeAll()
    }
    
    private func fetchData() {
        isLoading = true
        errorMessage = nil
        
        // TODO: Implement data fetching logic
        let sampleData = ${MODULE_NAME}Entity(
            title: "$MODULE_NAME",
            description: "This is a sample $MODULE_NAME module."
        )
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) { [weak self] in
            DispatchQueue.main.async {
                self?.isLoading = false
                self?.data = sampleData
            }
        }
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
    @ObservedObject var viewModel: ${MODULE_NAME}ViewModel
    
    var body: some View {
        VStack {
            if let data = viewModel.data {
                Text(data.title)
                    .font(.largeTitle)
                Text(data.description)
                    .font(.body)
                    .foregroundColor(.secondary)
            } else if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .navigationTitle("$MODULE_NAME")
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

// MARK: - UIHostingController
final class ${MODULE_NAME}ViewController: UIHostingController<${MODULE_NAME}View> {
    let viewModel: ${MODULE_NAME}ViewModel
    let router: ${MODULE_NAME}Router
    
    init(viewModel: ${MODULE_NAME}ViewModel, router: ${MODULE_NAME}Router) {
        self.viewModel = viewModel
        self.router = router
        super.init(rootView: ${MODULE_NAME}View(viewModel: viewModel))
        self.router.viewController = self
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

final class ${MODULE_NAME}Router: RouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let viewModel = ${MODULE_NAME}ViewModel()
        let router = ${MODULE_NAME}Router()
        let view = ${MODULE_NAME}ViewController(viewModel: viewModel, router: router)
        return view
    }
}
EOF

echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}Entity.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}ViewModel.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}View.swift"
echo -e "${GREEN}✓${NC} Created ${MODULE_NAME}Router.swift"
echo ""
echo -e "${GREEN}Successfully created MVVM module: $MODULE_NAME${NC}"
echo -e "${YELLOW}Location: $MODULE_DIR${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Add the new files to your Xcode project"
echo "2. Implement the business logic in ${MODULE_NAME}ViewModel.swift"
echo "3. Customize the UI in ${MODULE_NAME}View.swift"
echo "4. Add navigation in ${MODULE_NAME}Router.swift"

