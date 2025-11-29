#!/usr/bin/env python3
"""
Advanced FTGO UML Diagram Generator
Analyzes Java source code and generates detailed UML diagrams
"""

import os
import re
from pathlib import Path
from typing import List, Dict, Set

PROJECT_ROOT = "/home/yuvaraj/Projects/java-project-Gemini-PlantUML/ftgo-application"
OUTPUT_DIR = os.path.join(PROJECT_ROOT, "uml-diagrams")
SERVICES = {
    "ftgo-order-service": "Order Service",
    "ftgo-consumer-service": "Consumer Service",
    "ftgo-restaurant-service": "Restaurant Service",
    "ftgo-kitchen-service": "Kitchen Service",
    "ftgo-delivery-service": "Delivery Service",
    "ftgo-accounting-service": "Accounting Service",
    "ftgo-order-history-service": "Order History Service",
    "ftgo-api-gateway": "API Gateway",
}

def find_java_files(service_path: str) -> List[str]:
    """Find all Java files in a service"""
    java_files = []
    src_path = os.path.join(PROJECT_ROOT, service_path, "src/main/java")
    if os.path.exists(src_path):
        for root, dirs, files in os.walk(src_path):
            for file in files:
                if file.endswith(".java"):
                    java_files.append(os.path.join(root, file))
    return java_files

def extract_class_info(java_file: str) -> Dict:
    """Extract class information from Java file"""
    info = {
        "className": None,
        "packageName": None,
        "methods": [],
        "fields": [],
        "implements": [],
        "extends": None,
        "annotations": []
    }
    
    try:
        with open(java_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
            # Extract package
            pkg_match = re.search(r'package\s+([\w.]+);', content)
            if pkg_match:
                info["packageName"] = pkg_match.group(1)
            
            # Extract class name
            class_match = re.search(r'(?:public\s+)?(?:class|interface|enum)\s+(\w+)', content)
            if class_match:
                info["className"] = class_match.group(1)
            
            # Extract extends
            extends_match = re.search(r'class\s+\w+\s+extends\s+([\w.]+)', content)
            if extends_match:
                info["extends"] = extends_match.group(1)
            
            # Extract implements
            implements_match = re.search(r'class\s+\w+\s+(?:extends\s+[\w.]+\s+)?implements\s+([\w,\s.]+)', content)
            if implements_match:
                info["implements"] = [i.strip() for i in implements_match.group(1).split(",")]
            
            # Extract annotations
            annotations = re.findall(r'@(\w+)', content)
            info["annotations"] = list(set(annotations))
            
            # Extract methods
            methods = re.findall(r'(?:public|private|protected)?\s+(?:\w+\s+)+(\w+)\s*\([^)]*\)', content)
            info["methods"] = list(set(methods))[:10]  # Limit to 10
            
            # Extract fields
            fields = re.findall(r'(?:private|public|protected)?\s+(?:final\s+)?(\w+)\s+(\w+)\s*[;=]', content)
            info["fields"] = [(f[1], f[0]) for f in fields][:10]  # Limit to 10
    
    except Exception as e:
        pass
    
    return info

def generate_service_class_diagram(service_key: str, service_name: str):
    """Generate class diagram for a service"""
    java_files = find_java_files(service_key)
    
    if not java_files:
        return
    
    puml_content = f"@startuml {service_key.replace('-', '_').upper()}_Classes\n"
    puml_content += f"title {service_name} - Classes and Interfaces\n\n"
    
    classes_info = []
    for java_file in java_files[:15]:  # Limit to 15 files per service
        info = extract_class_info(java_file)
        if info["className"]:
            classes_info.append(info)
    
    # Generate class definitions
    for info in classes_info:
        if info["className"]:
            class_type = "interface" if "Service" in info["className"] or "Repository" in info["className"] else "class"
            puml_content += f"{class_type} {info['className']} {{\n"
            
            # Add fields
            for field_name, field_type in info["fields"]:
                puml_content += f"  {field_type} {field_name}\n"
            
            if info["fields"] and info["methods"]:
                puml_content += "  --\n"
            
            # Add methods
            for method in info["methods"]:
                puml_content += f"  + {method}()\n"
            
            puml_content += "}\n\n"
    
    # Add relationships
    if len(classes_info) > 1:
        for i in range(len(classes_info) - 1):
            puml_content += f"{classes_info[i]['className']} --> {classes_info[i+1]['className']}\n"
    
    puml_content += "\n@enduml\n"
    
    # Write file
    output_file = os.path.join(OUTPUT_DIR, f"09-{service_key}-classes.puml")
    with open(output_file, 'w') as f:
        f.write(puml_content)
    
    print(f"✓ Generated class diagram for {service_name}")

def generate_package_diagram():
    """Generate package structure diagram"""
    puml_content = "@startuml PackageStructure\n"
    puml_content += "title FTGO - Package Structure\n\n"
    
    puml_content += "package \"ftgo-order-service\" {\n"
    puml_content += "  package \"domain\" {}\n"
    puml_content += "  package \"messaging\" {}\n"
    puml_content += "  package \"web\" {}\n"
    puml_content += "  package \"service\" {}\n"
    puml_content += "}\n\n"
    
    puml_content += "package \"ftgo-consumer-service\" {\n"
    puml_content += "  package \"domain\" {}\n"
    puml_content += "  package \"web\" {}\n"
    puml_content += "  package \"service\" {}\n"
    puml_content += "}\n\n"
    
    puml_content += "package \"ftgo-restaurant-service\" {\n"
    puml_content += "  package \"domain\" {}\n"
    puml_content += "  package \"web\" {}\n"
    puml_content += "  package \"service\" {}\n"
    puml_content += "}\n\n"
    
    puml_content += "package \"ftgo-kitchen-service\" {\n"
    puml_content += "  package \"domain\" {}\n"
    puml_content += "  package \"messaging\" {}\n"
    puml_content += "  package \"service\" {}\n"
    puml_content += "}\n\n"
    
    puml_content += "package \"ftgo-accounting-service\" {\n"
    puml_content += "  package \"domain\" {}\n"
    puml_content += "  package \"web\" {}\n"
    puml_content += "  package \"service\" {}\n"
    puml_content += "  package \"saga\" {}\n"
    puml_content += "}\n\n"
    
    puml_content += "package \"ftgo-api-gateway\" {\n"
    puml_content += "  package \"controller\" {}\n"
    puml_content += "  package \"filter\" {}\n"
    puml_content += "  package \"proxy\" {}\n"
    puml_content += "}\n\n"
    
    puml_content += "@enduml\n"
    
    output_file = os.path.join(OUTPUT_DIR, "09-package-structure.puml")
    with open(output_file, 'w') as f:
        f.write(puml_content)
    
    print("✓ Generated package structure diagram")

def generate_component_interaction():
    """Generate component interaction diagram"""
    puml_content = "@startuml ComponentInteraction\n"
    puml_content += "title FTGO - Component Interaction Pattern\n\n"
    
    puml_content += "[Client Application] as Client\n"
    puml_content += "[REST Controller] as Controller\n"
    puml_content += "[Service Layer] as Service\n"
    puml_content += "[Repository] as Repo\n"
    puml_content += "[Domain Entity] as Entity\n"
    puml_content += "[Event Dispatcher] as EventDispatcher\n"
    puml_content += "[Message Broker] as Broker\n"
    puml_content += "database [Database]\n\n"
    
    puml_content += "Client -right-> Controller: HTTP Request\n"
    puml_content += "Controller -right-> Service: Process Request\n"
    puml_content += "Service -right-> Repo: Query/Save\n"
    puml_content += "Repo -right-> Entity: Work with Entity\n"
    puml_content += "Repo -right-> Database: Persist Data\n"
    puml_content += "Service -down-> EventDispatcher: Publish Event\n"
    puml_content += "EventDispatcher -right-> Broker: Send to Kafka\n"
    puml_content += "Controller -left-> Client: JSON Response\n\n"
    
    puml_content += "@enduml\n"
    
    output_file = os.path.join(OUTPUT_DIR, "10-component-interaction.puml")
    with open(output_file, 'w') as f:
        f.write(puml_content)
    
    print("✓ Generated component interaction diagram")

def main():
    print("\n========================================")
    print("Advanced UML Diagram Generator")
    print("========================================\n")
    
    os.makedirs(OUTPUT_DIR, exist_ok=True)
    
    print("Analyzing Java source code...")
    print()
    
    # Generate class diagrams for each service
    for service_key, service_name in SERVICES.items():
        generate_service_class_diagram(service_key, service_name)
    
    print()
    generate_package_diagram()
    generate_component_interaction()
    
    print("\n========================================")
    print("Code Analysis Complete!")
    print("========================================\n")
    
    # List all generated files
    print("All PlantUML diagrams:")
    for f in sorted(os.listdir(OUTPUT_DIR)):
        if f.endswith('.puml'):
            path = os.path.join(OUTPUT_DIR, f)
            size = os.path.getsize(path)
            print(f"  ✓ {f} ({size} bytes)")
    
    print(f"\nTotal diagrams: {len([f for f in os.listdir(OUTPUT_DIR) if f.endswith('.puml')])}")
    print(f"\nLocation: {OUTPUT_DIR}")

if __name__ == "__main__":
    main()
