#!/bin/bash

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

API_BASE_URL="http://4.213.154.131"
DATA_FILE="../test-data/sample-data.json"

echo -e "\n${BLUE}=== Loading Sample Data to Azure Application ===${NC}\n"
echo "Target: $API_BASE_URL"
echo ""

# Step 1: Health Check
echo -e "${BLUE}Step 1: Health Check${NC}"
HEALTH_RESPONSE=$(curl -s -w "\n%{http_code}" "${API_BASE_URL}/health" --max-time 10)
HTTP_CODE=$(echo "$HEALTH_RESPONSE" | tail -n1)
if [ "$HTTP_CODE" == "200" ]; then
    echo -e "${GREEN}✓${NC} API is healthy"
else
    echo -e "${RED}✗${NC} API health check failed (HTTP $HTTP_CODE)"
    exit 1
fi
echo ""

# Step 2: Create VC user
echo -e "${BLUE}Step 2: Creating VC Demo User${NC}"
VC_REGISTER_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${API_BASE_URL}/api/register" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "vc@demo.com",
        "password": "Demo@123",
        "full_name": "Demo VC Investor",
        "role": "vc_representative"
    }')
HTTP_CODE=$(echo "$VC_REGISTER_RESPONSE" | tail -n1)
if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "201" ]; then
    echo -e "${GREEN}✓${NC} Created VC user: vc@demo.com"
elif [ "$HTTP_CODE" == "400" ] || [ "$HTTP_CODE" == "422" ]; then
    BODY=$(echo "$VC_REGISTER_RESPONSE" | head -n-1)
    if echo "$BODY" | grep -q "already registered" || echo "$BODY" | grep -q "exists"; then
        echo -e "${YELLOW}→${NC} User already exists: vc@demo.com"
    else
        echo -e "${RED}✗${NC} Failed to create VC user (HTTP $HTTP_CODE)"
        echo "$BODY"
    fi
else
    echo -e "${RED}✗${NC} Failed to create VC user (HTTP $HTTP_CODE)"
    echo "$VC_REGISTER_RESPONSE" | head -n-1
fi
echo ""

# Step 3: Create Startup user
echo -e "${BLUE}Step 3: Creating Startup Demo User${NC}"
STARTUP_REGISTER_RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${API_BASE_URL}/api/register" \
    -H "Content-Type: application/json" \
    -d '{
        "email": "startup@demo.com",
        "password": "Demo@123",
        "full_name": "Demo Startup Founder",
        "role": "startup_aspirant"
    }')
HTTP_CODE=$(echo "$STARTUP_REGISTER_RESPONSE" | tail -n1)
if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "201" ]; then
    echo -e "${GREEN}✓${NC} Created startup user: startup@demo.com"
elif [ "$HTTP_CODE" == "400" ] || [ "$HTTP_CODE" == "422" ]; then
    BODY=$(echo "$STARTUP_REGISTER_RESPONSE" | head -n-1)
    if echo "$BODY" | grep -q "already registered" || echo "$BODY" | grep -q "exists"; then
        echo -e "${YELLOW}→${NC} User already exists: startup@demo.com"
    else
        echo -e "${RED}✗${NC} Failed to create startup user (HTTP $HTTP_CODE)"
        echo "$BODY"
    fi
else
    echo -e "${RED}✗${NC} Failed to create startup user (HTTP $HTTP_CODE)"
    echo "$STARTUP_REGISTER_RESPONSE" | head -n-1
fi
echo ""

# Step 4: Login as VC
echo -e "${BLUE}Step 4: Logging in as VC${NC}"
VC_LOGIN_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/api/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "username=vc@demo.com&password=Demo@123")
VC_TOKEN=$(echo "$VC_LOGIN_RESPONSE" | jq -r '.access_token')
if [ "$VC_TOKEN" != "null" ] && [ ! -z "$VC_TOKEN" ]; then
    echo -e "${GREEN}✓${NC} Logged in as VC"
else
    echo -e "${RED}✗${NC} Failed to login as VC"
    echo "$VC_LOGIN_RESPONSE"
    exit 1
fi
echo ""

# Step 5: Load VC use cases
echo -e "${BLUE}Step 5: Creating VC Use Cases${NC}"
cat "$DATA_FILE" | jq -c '.vc_usecases[]' | while read -r usecase; do
    TITLE=$(echo "$usecase" | jq -r '.title')
    DESCRIPTION=$(echo "$usecase" | jq -r '.description')
    INDUSTRY=$(echo "$usecase" | jq -r '.market // "Technology"')
    DOMAIN=$(echo "$usecase" | jq -r '.industry // "Enterprise Software"')
    
    # Create a simplified payload matching the API schema
    PAYLOAD=$(jq -n \
        --arg title "$TITLE" \
        --arg description "$DESCRIPTION" \
        --arg industry "$INDUSTRY" \
        --arg domain "$DOMAIN" \
        '{
            title: $title,
            description: $description,
            industry: $industry,
            domain: $domain,
            tags: ["demo", "sample"],
            importance_weight: 0.5
        }')
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${API_BASE_URL}/api/vc/usecases" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $VC_TOKEN" \
        -d "$PAYLOAD")
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "201" ]; then
        echo -e "${GREEN}✓${NC} Created: $TITLE"
    else
        echo -e "${RED}✗${NC} Failed to create: $TITLE (HTTP $HTTP_CODE)"
        echo "$RESPONSE" | head -n-1
    fi
    sleep 0.5  # Rate limiting
done
echo ""

# Step 6: Login as Startup
echo -e "${BLUE}Step 6: Logging in as Startup${NC}"
STARTUP_LOGIN_RESPONSE=$(curl -s -X POST "${API_BASE_URL}/api/token" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "username=startup@demo.com&password=Demo@123")
STARTUP_TOKEN=$(echo "$STARTUP_LOGIN_RESPONSE" | jq -r '.access_token')
if [ "$STARTUP_TOKEN" != "null" ] && [ ! -z "$STARTUP_TOKEN" ]; then
    echo -e "${GREEN}✓${NC} Logged in as Startup"
else
    echo -e "${RED}✗${NC} Failed to login as Startup"
    echo "$STARTUP_LOGIN_RESPONSE"
    exit 1
fi
echo ""

# Step 7: Load startup ideas
echo -e "${BLUE}Step 7: Creating Startup Ideas${NC}"
cat "$DATA_FILE" | jq -c '.startup_ideas[]' | while read -r startup; do
    NAME=$(echo "$startup" | jq -r '.name')
    TAGLINE=$(echo "$startup" | jq -r '.tagline // .description[:100]')
    PROBLEM=$(echo "$startup" | jq -r '.problem')
    SOLUTION=$(echo "$startup" | jq -r '.solution')
    MARKET=$(echo "$startup" | jq -r '.market // "Technology"')
    DIFF=$(echo "$startup" | jq -r '.differentiation')
    SIGNALS=$(echo "$startup" | jq -r '(.traction | tostring)')
    
    # Create a simplified payload matching the API schema
    PAYLOAD=$(jq -n \
        --arg title "$NAME" \
        --arg pitch "$TAGLINE" \
        --arg problem "$PROBLEM" \
        --arg solution "$SOLUTION" \
        --arg industry "$MARKET" \
        --arg diff "$DIFF" \
        --arg signals "$SIGNALS" \
        '{
            title: $title,
            short_pitch: $pitch,
            problem_statement: $problem,
            proposed_solution: $solution,
            target_industry: $industry,
            differentiators: $diff,
            market_signals: $signals
        }')
    
    RESPONSE=$(curl -s -w "\n%{http_code}" -X POST "${API_BASE_URL}/api/ideas" \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $STARTUP_TOKEN" \
        -d "$PAYLOAD")
    HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
    if [ "$HTTP_CODE" == "200" ] || [ "$HTTP_CODE" == "201" ]; then
        echo -e "${GREEN}✓${NC} Created: $NAME"
    else
        echo -e "${RED}✗${NC} Failed to create: $NAME (HTTP $HTTP_CODE)"
        echo "$RESPONSE" | head -n-1
    fi
    sleep 0.5  # Rate limiting
done
echo ""

# Summary
echo -e "${GREEN}=== ✓ Sample Data Loaded Successfully ===${NC}\n"
echo -e "${BLUE}Summary:${NC}"
echo "  • VC Use Cases: 5"
echo "  • Startup Ideas: 5"
echo "  • Demo Accounts:"
echo "    - vc@demo.com (password: Demo@123)"
echo "    - startup@demo.com (password: Demo@123)"
echo -e "\n${BLUE}Access your application at:${NC}"
echo "  $API_BASE_URL"
echo ""
