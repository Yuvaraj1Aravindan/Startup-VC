#!/bin/bash

# FTGO Microservices UML Diagram Generator
# This script generates comprehensive UML diagrams for the FTGO application

PROJECT_ROOT="/home/yuvaraj/Projects/java-project-Gemini-PlantUML/ftgo-application"
OUTPUT_DIR="${PROJECT_ROOT}/uml-diagrams"

# Create output directory
mkdir -p "${OUTPUT_DIR}"

echo "=========================================="
echo "FTGO Microservices UML Diagram Generator"
echo "=========================================="
echo ""

# Function to extract classes from Java files
extract_classes() {
    local service_path=$1
    local service_name=$2
    
    echo "Analyzing ${service_name}..."
    
    find "${service_path}" -name "*.java" -type f | head -20
}

# Generate Architecture Diagram
generate_architecture_diagram() {
    cat > "${OUTPUT_DIR}/01-architecture.puml" << 'EOF'
@startuml FTGO_Architecture
!define DIRECTION top to bottom

title FTGO Microservices Architecture

package "API Gateway" {
    component [API Gateway] as APIGateway
}

package "Core Services" {
    component [Order Service] as OrderService
    component [Consumer Service] as ConsumerService
    component [Restaurant Service] as RestaurantService
    component [Kitchen Service] as KitchenService
    component [Delivery Service] as DeliveryService
    component [Accounting Service] as AccountingService
}

package "Data Services" {
    component [Order History Service\n(CQRS View)] as OrderHistoryService
}

package "Message Bus" {
    component [Apache Kafka] as Kafka
}

package "Data Storage" {
    database "MySQL\n(Order DB)" as OrderDB
    database "MySQL\n(Consumer DB)" as ConsumerDB
    database "MySQL\n(Restaurant DB)" as RestaurantDB
    database "MySQL\n(Kitchen DB)" as KitchenDB
    database "MySQL\n(Accounting DB)" as AccountingDB
    database "Elasticsearch" as ES
}

APIGateway --> OrderService : HTTP/REST
APIGateway --> ConsumerService : HTTP/REST
APIGateway --> RestaurantService : HTTP/REST

OrderService --> Kafka : Publish Events
ConsumerService --> Kafka : Publish Events
RestaurantService --> Kafka : Publish Events
KitchenService --> Kafka : Consume Events
DeliveryService --> Kafka : Consume Events
AccountingService --> Kafka : Consume Events
OrderHistoryService --> Kafka : Consume Events

OrderService --> OrderDB : SQL
ConsumerService --> ConsumerDB : SQL
RestaurantService --> RestaurantDB : SQL
KitchenService --> KitchenDB : SQL
AccountingService --> AccountingDB : SQL
OrderHistoryService --> ES : Index

note right of APIGateway
  Entry point for all client requests
  Routes to appropriate microservices
end note

note right of Kafka
  Event-driven architecture
  Transactional messaging
  Saga pattern implementation
end note

@enduml
EOF
    echo "✓ Generated: 01-architecture.puml"
}

# Generate Order Service Class Diagram
generate_order_service_diagram() {
    cat > "${OUTPUT_DIR}/02-order-service-domain.puml" << 'EOF'
@startuml OrderServiceDomain
title Order Service - Domain Model

package "Order Service Domain" {
    
    class Order {
        - id: Long
        - consumerId: Long
        - restaurantId: Long
        - deliveryAddress: Address
        - state: OrderState
        - lineItems: List<LineItem>
        - createdAt: LocalDateTime
        --
        + Order()
        + addLineItem(item: LineItem): void
        + updateState(state: OrderState): void
        + getTotal(): BigDecimal
    }
    
    class LineItem {
        - id: Long
        - menuItemId: Long
        - quantity: Integer
        - price: BigDecimal
        --
        + LineItem(menuItemId, quantity, price)
        + getTotal(): BigDecimal
    }
    
    enum OrderState {
        PENDING
        APPROVED
        CONFIRMED
        PREPARING
        READY_FOR_DELIVERY
        DELIVERED
        CANCELLED
    }
    
    class Address {
        - street: String
        - city: String
        - state: String
        - zipCode: String
        --
        + Address()
        + getFullAddress(): String
    }
    
    class OrderRepository {
        + save(order: Order): void
        + findById(id: Long): Order
        + findByConsumerId(id: Long): List<Order>
    }
    
    class OrderService {
        - orderRepository: OrderRepository
        - eventPublisher: EventPublisher
        --
        + createOrder(createOrderRequest): Order
        + approveOrder(orderId): void
        + confirmOrder(orderId): void
    }
    
    class OrderSaga {
        - orderService: OrderService
        --
        + createOrderSaga(createOrderRequest): void
    }
}

Order "1" -- "*" LineItem : contains
Order "1" -- "1" OrderState : has
Order "1" -- "1" Address : delivers_to
OrderRepository --> Order : manages
OrderService --> OrderRepository : uses
OrderService --> Order : creates/updates
OrderSaga --> OrderService : orchestrates

@enduml
EOF
    echo "✓ Generated: 02-order-service-domain.puml"
}

# Generate Consumer Service Class Diagram
generate_consumer_service_diagram() {
    cat > "${OUTPUT_DIR}/03-consumer-service-domain.puml" << 'EOF'
@startuml ConsumerServiceDomain
title Consumer Service - Domain Model

package "Consumer Service Domain" {
    
    class Consumer {
        - id: Long
        - name: String
        - email: String
        - phone: String
        - addresses: List<Address>
        - createdAt: LocalDateTime
        --
        + Consumer()
        + addAddress(address: Address): void
        + updateProfile(name, email): void
    }
    
    class Address {
        - id: Long
        - type: AddressType
        - street: String
        - city: String
        - state: String
        - zipCode: String
        --
        + Address()
        + isValid(): boolean
    }
    
    enum AddressType {
        HOME
        WORK
        OTHER
    }
    
    class ConsumerRepository {
        + save(consumer: Consumer): void
        + findById(id: Long): Consumer
        + findByEmail(email: String): Consumer
    }
    
    class ConsumerService {
        - consumerRepository: ConsumerRepository
        - eventPublisher: EventPublisher
        --
        + createConsumer(createConsumerRequest): Consumer
        + updateProfile(consumerId, updates): void
        + validateConsumer(consumerId): boolean
    }
}

Consumer "1" -- "*" Address : has
Address --> AddressType : type
ConsumerRepository --> Consumer : manages
ConsumerService --> ConsumerRepository : uses

@enduml
EOF
    echo "✓ Generated: 03-consumer-service-domain.puml"
}

# Generate Restaurant Service Class Diagram
generate_restaurant_service_diagram() {
    cat > "${OUTPUT_DIR}/04-restaurant-service-domain.puml" << 'EOF'
@startuml RestaurantServiceDomain
title Restaurant Service - Domain Model

package "Restaurant Service Domain" {
    
    class Restaurant {
        - id: Long
        - name: String
        - address: Address
        - menu: Menu
        - status: RestaurantStatus
        --
        + Restaurant()
        + updateMenu(menu: Menu): void
        + getMenu(): Menu
    }
    
    enum RestaurantStatus {
        OPEN
        CLOSED
        UNDER_MAINTENANCE
    }
    
    class Menu {
        - id: Long
        - restaurantId: Long
        - items: List<MenuItem>
        - version: Long
        --
        + Menu()
        + addMenuItem(item: MenuItem): void
        + removeMenuItem(itemId: Long): void
    }
    
    class MenuItem {
        - id: Long
        - name: String
        - description: String
        - price: BigDecimal
        - available: boolean
        --
        + MenuItem()
        + isAvailable(): boolean
    }
    
    class Address {
        - street: String
        - city: String
        - state: String
        - zipCode: String
    }
    
    class RestaurantRepository {
        + save(restaurant: Restaurant): void
        + findById(id: Long): Restaurant
        + findAll(): List<Restaurant>
    }
    
    class RestaurantService {
        - restaurantRepository: RestaurantRepository
        --
        + createRestaurant(request): Restaurant
        + updateMenu(restaurantId, menu): void
    }
}

Restaurant "1" -- "1" Menu : has
Restaurant "1" -- "1" Address : located_at
Restaurant "1" -- "1" RestaurantStatus : has_status
Menu "1" -- "*" MenuItem : contains
RestaurantRepository --> Restaurant : manages
RestaurantService --> RestaurantRepository : uses

@enduml
EOF
    echo "✓ Generated: 04-restaurant-service-domain.puml"
}

# Generate API Gateway Class Diagram
generate_api_gateway_diagram() {
    cat > "${OUTPUT_DIR}/05-api-gateway.puml" << 'EOF'
@startuml APIGatewayArchitecture
title API Gateway Architecture

package "API Gateway" {
    
    interface HttpRequest
    
    class ApiGatewayController {
        - orderServiceProxy: OrderServiceProxy
        - consumerServiceProxy: ConsumerServiceProxy
        - restaurantServiceProxy: RestaurantServiceProxy
        --
        + createOrder(request): OrderResponse
        + getOrder(orderId): OrderResponse
        + createConsumer(request): ConsumerResponse
        + createRestaurant(request): RestaurantResponse
    }
    
    class AuthenticationFilter {
        + authenticate(request): boolean
    }
    
    class RateLimiter {
        + checkRateLimit(clientId): boolean
    }
    
    class RequestRouter {
        + route(request): ServiceProxy
    }
    
    class OrderServiceProxy {
        - baseUrl: String
        + createOrder(request): OrderResponse
        + getOrder(orderId): OrderResponse
    }
    
    class ConsumerServiceProxy {
        - baseUrl: String
        + createConsumer(request): ConsumerResponse
    }
    
    class RestaurantServiceProxy {
        - baseUrl: String
        + getRestaurant(id): RestaurantResponse
        + searchRestaurants(criteria): List<RestaurantResponse>
    }
    
    class ResponseTransformer {
        + transform(response): TransformedResponse
    }
}

HttpRequest --> AuthenticationFilter : validates
AuthenticationFilter --> RateLimiter : checks
RateLimiter --> RequestRouter : routes
RequestRouter --> ApiGatewayController : dispatches
ApiGatewayController --> OrderServiceProxy : calls
ApiGatewayController --> ConsumerServiceProxy : calls
ApiGatewayController --> RestaurantServiceProxy : calls
OrderServiceProxy --> ResponseTransformer : transforms
ConsumerServiceProxy --> ResponseTransformer : transforms
RestaurantServiceProxy --> ResponseTransformer : transforms

@enduml
EOF
    echo "✓ Generated: 05-api-gateway.puml"
}

# Generate Event-Driven Architecture Diagram
generate_event_driven_diagram() {
    cat > "${OUTPUT_DIR}/06-event-driven-architecture.puml" << 'EOF'
@startuml EventDrivenArchitecture
title Event-Driven Microservices Architecture

package "Event Sources" {
    component [Order Service] as OrderSvc
    component [Consumer Service] as ConsumerSvc
    component [Restaurant Service] as RestaurantSvc
}

package "Message Broker" {
    component [Kafka Topics] as KafkaTopics
}

package "Event Consumers" {
    component [Kitchen Service] as KitchenSvc
    component [Delivery Service] as DeliverySvc
    component [Accounting Service] as AccountingSvc
    component [Order History Service] as HistorySvc
}

package "Saga Orchestrators" {
    component [Order Saga Orchestrator] as OrderSaga
}

OrderSvc -.->|Publishes: OrderCreated\nOrderApproved\nOrderConfirmed| KafkaTopics : Events
ConsumerSvc -.->|Publishes: ConsumerCreated\nConsumerVerified| KafkaTopics : Events
RestaurantSvc -.->|Publishes: RestaurantCreated\nMenuUpdated| KafkaTopics : Events

KafkaTopics -.->|Consumes: OrderCreated\nOrderApproved| KitchenSvc : Events
KafkaTopics -.->|Consumes: OrderConfirmed\nOrderReady| DeliverySvc : Events
KafkaTopics -.->|Consumes: OrderCreated\nOrderConfirmed| AccountingSvc : Events
KafkaTopics -.->|Consumes: All Events| HistorySvc : Events

OrderSaga -.->|Orchestrates| KafkaTopics : Commands/Events
OrderSaga --> OrderSvc : Requests
OrderSaga --> KitchenSvc : Requests
OrderSaga --> DeliverySvc : Requests
OrderSaga --> AccountingSvc : Requests

note right of KafkaTopics
  Event topics:
  - orders
  - consumers
  - restaurants
  - deliveries
  - accounting
end note

note right of OrderSaga
  Implements Order Creation Saga
  Ensures consistency across services
  Handles compensating transactions
end note

@enduml
EOF
    echo "✓ Generated: 06-event-driven-architecture.puml"
}

# Generate Data Flow Diagram
generate_data_flow_diagram() {
    cat > "${OUTPUT_DIR}/07-order-creation-sequence.puml" << 'EOF'
@startuml OrderCreationSequence
title Order Creation Process - Sequence Diagram

actor Client
participant "API Gateway" as Gateway
participant "Order Service" as OrderSvc
participant "Kafka" as Kafka
participant "Restaurant Service" as RestaurantSvc
participant "Kitchen Service" as KitchenSvc
participant "Accounting Service" as AccountingSvc
database "Order DB" as OrderDB
database "Accounting DB" as AcctDB

Client ->> Gateway: POST /orders {createOrderRequest}
Gateway ->> OrderSvc: Create Order
OrderSvc ->> OrderDB: Save Order (state: PENDING)
OrderSvc ->> Kafka: Publish OrderCreated Event
Kafka ->> RestaurantSvc: OrderCreated Event
RestaurantSvc ->> OrderSvc: Validate Order Items
OrderSvc ->> Kafka: Publish OrderApproved Event
Kafka ->> KitchenSvc: OrderApproved Event
Kafka ->> AccountingSvc: OrderApproved Event
KitchenSvc ->> OrderSvc: Confirm Receipt
AccountingSvc ->> AcctDB: Reserve Funds
AccountingSvc ->> Kafka: Publish PaymentProcessed Event
Kafka ->> OrderSvc: PaymentProcessed Event
OrderSvc ->> OrderDB: Update Order (state: CONFIRMED)
OrderSvc ->> Gateway: Order Created Successfully
Gateway ->> Client: Return Order (201 Created)

@enduml
EOF
    echo "✓ Generated: 07-order-creation-sequence.puml"
}

# Generate Service Dependencies Diagram
generate_service_dependencies() {
    cat > "${OUTPUT_DIR}/08-service-dependencies.puml" << 'EOF'
@startuml ServiceDependencies
title FTGO Microservices Dependencies

!define SERVICE_COLOR #FFE6E6
!define LIB_COLOR #E6F2FF
!define TECH_COLOR #E6F2E6

package "Microservices" {
    [API Gateway]
    [Order Service]
    [Consumer Service]
    [Restaurant Service]
    [Kitchen Service]
    [Delivery Service]
    [Accounting Service]
    [Order History Service]
}

package "Shared Libraries" {
    [FTGO Common]
    [FTGO Common JPA]
    [FTGO Test Util]
}

package "Technologies" {
    [Spring Boot]
    [Spring Data JPA]
    [Spring Web]
    [Eventuate Tram]
    [Eventuate Saga]
    [Eventuate Client]
    [Kafka]
    [MySQL]
    [Elasticsearch]
}

[API Gateway] --> [Spring Boot]
[API Gateway] --> [Spring Web]
[API Gateway] --> [FTGO Common]

[Order Service] --> [Spring Boot]
[Order Service] --> [Spring Data JPA]
[Order Service] --> [Eventuate Tram]
[Order Service] --> [Eventuate Saga]
[Order Service] --> [FTGO Common]
[Order Service] --> [FTGO Common JPA]
[Order Service] --> [Kafka]
[Order Service] --> [MySQL]

[Consumer Service] --> [Spring Boot]
[Consumer Service] --> [Spring Data JPA]
[Consumer Service] --> [FTGO Common]
[Consumer Service] --> [MySQL]

[Restaurant Service] --> [Spring Boot]
[Restaurant Service] --> [Spring Data JPA]
[Restaurant Service] --> [FTGO Common]
[Restaurant Service] --> [MySQL]

[Kitchen Service] --> [Spring Boot]
[Kitchen Service] --> [Eventuate Client]
[Kitchen Service] --> [FTGO Common]
[Kitchen Service] --> [Kafka]
[Kitchen Service] --> [MySQL]

[Delivery Service] --> [Spring Boot]
[Delivery Service] --> [Eventuate Client]
[Delivery Service] --> [FTGO Common]
[Delivery Service] --> [Kafka]

[Accounting Service] --> [Spring Boot]
[Accounting Service] --> [Spring Data JPA]
[Accounting Service] --> [Eventuate Tram]
[Accounting Service] --> [FTGO Common]
[Accounting Service] --> [Kafka]
[Accounting Service] --> [MySQL]

[Order History Service] --> [Spring Boot]
[Order History Service] --> [Eventuate Client]
[Order History Service] --> [FTGO Common]
[Order History Service] --> [Elasticsearch]

@enduml
EOF
    echo "✓ Generated: 08-service-dependencies.puml"
}

# Main execution
echo ""
echo "Generating UML Diagrams..."
echo ""

generate_architecture_diagram
generate_order_service_diagram
generate_consumer_service_diagram
generate_restaurant_service_diagram
generate_api_gateway_diagram
generate_event_driven_diagram
generate_data_flow_diagram
generate_service_dependencies

echo ""
echo "=========================================="
echo "UML Diagram Generation Complete!"
echo "=========================================="
echo ""
echo "Generated diagrams in: ${OUTPUT_DIR}"
echo ""
echo "Diagrams created:"
echo "  1. Architecture - System overview"
echo "  2. Order Service - Domain model"
echo "  3. Consumer Service - Domain model"
echo "  4. Restaurant Service - Domain model"
echo "  5. API Gateway - Architecture"
echo "  6. Event-Driven Architecture"
echo "  7. Order Creation Sequence"
echo "  8. Service Dependencies"
echo ""
echo "To visualize these diagrams, you can:"
echo "  - Open them in VS Code with the PlantUML Preview extension"
echo "  - Generate PNG/SVG using: plantuml <filename>"
echo ""

# List generated files
echo "Generated files:"
ls -lh "${OUTPUT_DIR}"/*.puml
