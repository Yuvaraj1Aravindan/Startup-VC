#!/bin/bash
# View all generated UML diagrams in one command

PROJECT_PATH="/home/yuvaraj/Projects/java-project-Gemini-PlantUML/ftgo-application/uml-diagrams"

echo "========================================"
echo "FTGO UML Diagrams - Quick Reference"
echo "========================================"
echo ""
echo "📂 Diagrams Location:"
echo "   $PROJECT_PATH"
echo ""
echo "📊 Generated UML Files:"
echo ""

# Counter
count=1

# List and categorize diagrams
echo "SYSTEM ARCHITECTURE:"
for file in $PROJECT_PATH/01-*.puml $PROJECT_PATH/06-*.puml $PROJECT_PATH/07-*.puml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        size=$(ls -lh "$file" | awk '{print $5}')
        echo "  $count. $filename ($size)"
        count=$((count + 1))
    fi
done

echo ""
echo "DOMAIN MODELS:"
for file in $PROJECT_PATH/02-*.puml $PROJECT_PATH/03-*.puml $PROJECT_PATH/04-*.puml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        size=$(ls -lh "$file" | awk '{print $5}')
        echo "  $count. $filename ($size)"
        count=$((count + 1))
    fi
done

echo ""
echo "SERVICE & INFRASTRUCTURE:"
for file in $PROJECT_PATH/05-*.puml $PROJECT_PATH/08-*.puml $PROJECT_PATH/09-package*.puml $PROJECT_PATH/10-*.puml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        size=$(ls -lh "$file" | awk '{print $5}')
        echo "  $count. $filename ($size)"
        count=$((count + 1))
    fi
done

echo ""
echo "SERVICE-SPECIFIC CLASSES:"
for file in $PROJECT_PATH/09-ftgo-*.puml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        size=$(ls -lh "$file" | awk '{print $5}')
        echo "  $count. $filename ($size)"
        count=$((count + 1))
    fi
done

echo ""
echo "========================================"
echo "🎯 RECOMMENDED VIEWING ORDER:"
echo "========================================"
echo ""
echo "Step 1: System Overview"
echo "  → Open: 01-architecture.puml"
echo "  Purpose: Understand overall system design"
echo ""
echo "Step 2: Communication Patterns"
echo "  → Open: 06-event-driven-architecture.puml"
echo "  Purpose: Learn how services interact via events"
echo ""
echo "Step 3: Business Process"
echo "  → Open: 07-order-creation-sequence.puml"
echo "  Purpose: Trace a complete order creation flow"
echo ""
echo "Step 4: Domain Models"
echo "  → Open: 02-order-service-domain.puml"
echo "  → Open: 03-consumer-service-domain.puml"
echo "  → Open: 04-restaurant-service-domain.puml"
echo "  Purpose: Understand data structures and relationships"
echo ""
echo "Step 5: Infrastructure"
echo "  → Open: 05-api-gateway.puml"
echo "  → Open: 08-service-dependencies.puml"
echo "  Purpose: See how components integrate"
echo ""
echo "Step 6: Implementation Details"
echo "  → Open: 09-ftgo-*-classes.puml (any service)"
echo "  Purpose: Review actual class hierarchies"
echo ""
echo ""
echo "========================================"
echo "🔗 HOW TO VIEW DIAGRAMS:"
echo "========================================"
echo ""
echo "VS Code Method (Recommended):"
echo "  1. Install 'PlantUML Preview' extension"
echo "  2. Open any .puml file"
echo "  3. Press Alt+D to view"
echo ""
echo "Online Method:"
echo "  1. Visit: http://www.plantuml.com/plantuml/uml/"
echo "  2. Copy content from any .puml file"
echo "  3. Paste and view"
echo ""
echo "PNG Export Method:"
echo "  1. Install PlantUML: sudo apt-get install plantuml"
echo "  2. Generate images: plantuml *.puml"
echo "  3. View: eog *.png  (or your image viewer)"
echo ""
echo ""
echo "========================================"
echo "📚 DIAGRAM DESCRIPTIONS:"
echo "========================================"
echo ""

cat << 'EOF'
01-architecture.puml
  High-level system architecture showing:
  - 8 microservices (Order, Consumer, Restaurant, Kitchen, Delivery, Accounting, History, Gateway)
  - API Gateway as entry point
  - Apache Kafka for event messaging
  - MySQL databases (one per service)
  - Elasticsearch for Order History search
  Relationships: HTTP/REST communication, event publishing

02-order-service-domain.puml
  Order Service domain model:
  - Order aggregate root
  - LineItem value objects
  - OrderState state machine (PENDING, APPROVED, CONFIRMED, PREPARING, READY, DELIVERED)
  - Address entity
  Patterns: DDD, Aggregate Root, State Pattern

03-consumer-service-domain.puml
  Consumer Service domain model:
  - Consumer aggregate
  - Address collection (Home, Work, Other)
  - Consumer repository and service
  Patterns: DDD, Collection management, One-to-Many relationships

04-restaurant-service-domain.puml
  Restaurant Service domain model:
  - Restaurant entity
  - Menu containing MenuItems
  - RestaurantStatus (OPEN, CLOSED, UNDER_MAINTENANCE)
  - Item availability tracking
  Patterns: DDD, Menu management, Inventory pattern

05-api-gateway.puml
  API Gateway architecture:
  - Incoming HTTP requests
  - Authentication filter (security)
  - Rate limiter (throttling)
  - Request router (dispatching)
  - Service proxies (Order, Consumer, Restaurant)
  - Response transformer (formatting)
  Patterns: API Gateway, Proxy, Filter Chain

06-event-driven-architecture.puml
  Event-driven microservices:
  - Event sources: Order, Consumer, Restaurant services
  - Event broker: Kafka topics
  - Event consumers: Kitchen, Delivery, Accounting, Order History
  - Saga orchestrator: Order Saga (distributed transaction)
  Patterns: Event-Driven, Saga, Pub/Sub

07-order-creation-sequence.puml
  Order creation sequence diagram:
  - Client initiates order
  - API Gateway receives request
  - Order Service saves and publishes event
  - Other services subscribe and react
  - Funds reserved, confirmation sent
  - Client receives order ID
  Patterns: Choreography Saga, Asynchronous Messaging

08-service-dependencies.puml
  Service dependency graph:
  - All services depend on Spring Boot
  - Specific dependencies: Spring Data JPA, Spring Web, Kafka, Hibernate
  - Shared libraries: FTGO Common, FTGO Common JPA
  - External: MySQL, Elasticsearch, Kafka
  Patterns: Dependency Management, Shared Libraries

09-package-structure.puml
  Standard package layout per service:
  - domain: Business logic, aggregates, entities
  - web: REST controllers, request/response
  - messaging: Event handlers, publishers
  - service: Business services, orchestration
  - saga: Saga orchestrators (Order Service, Accounting)
  Pattern: Layered Architecture

10-component-interaction.puml
  Component interaction within a service:
  - HTTP request enters controller
  - Controller calls service
  - Service uses repository
  - Repository persists entity
  - Service publishes event to Kafka
  - Response returned to client
  Pattern: Layered Architecture, Request/Response Flow

09-ftgo-*-classes.puml
  Service-specific class hierarchies:
  - Actual classes extracted from source code
  - Methods and fields from implementation
  - Repository and service interfaces
  One file per service showing real structure
  Pattern: Code generation, Reflection

09-package-structure.puml
  Package organization diagram:
  Shows standard package structure across all services
  Enables team consistency and clear organization

10-component-interaction.puml
  Reusable component pattern:
  Standard flow that each service follows
  Request → Controller → Service → Repository → Database
  With event publication to message bus

EOF

echo ""
echo "========================================"
echo "🛠️ TOOLS INCLUDED:"
echo "========================================"
echo ""
echo "📄 generate-uml-diagrams.sh"
echo "   Bash script that generates architecture diagrams"
echo "   Run: bash generate-uml-diagrams.sh"
echo ""
echo "🐍 analyze-and-generate-uml.py"
echo "   Python script that analyzes Java source code"
echo "   Extracts classes and generates detailed diagrams"
echo "   Run: python3 analyze-and-generate-uml.py"
echo ""
echo "📋 SETUP_GUIDE.sh"
echo "   Complete setup and troubleshooting guide"
echo "   Shows system info, project structure, and instructions"
echo "   Run: bash SETUP_GUIDE.sh"
echo ""
echo ""
echo "========================================"
echo "📖 DOCUMENTATION:"
echo "========================================"
echo ""
echo "README.md"
echo "   Comprehensive documentation of all diagrams"
echo "   Explanations of patterns and architecture"
echo "   Building and running instructions"
echo ""
echo "PROJECT_SUMMARY.md"
echo "   Executive summary of the entire project"
echo "   Statistics, technology stack, key patterns"
echo "   Next steps and learning resources"
echo ""
echo ""
echo "========================================"
echo "✨ QUICK START:"
echo "========================================"
echo ""
echo "# View all diagrams (pick one)"
echo "1. Install PlantUML extension in VS Code"
echo "2. Open uml-diagrams/01-architecture.puml"
echo "3. Press Alt+D"
echo ""
echo ""

# Show file count and total size
echo "📊 Statistics:"
total_files=$(find "$PROJECT_PATH" -name "*.puml" | wc -l)
total_size=$(du -sh "$PROJECT_PATH" | awk '{print $1}')
echo "   Total PUML files: $total_files"
echo "   Total size: $total_size"
echo ""
