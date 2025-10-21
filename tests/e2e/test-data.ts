/**
 * Test Data for VC UseCase Scoring Platform
 * 5 VC Use Cases and 5 Startup Ideas for comprehensive testing
 */

export const vcUseCases = [
  {
    id: 1,
    title: "AI-Powered Healthcare Diagnostics",
    description: "We invest in early-stage healthtech startups that leverage AI and machine learning to improve diagnostic accuracy in medical imaging. Our focus is on companies with FDA-approved algorithms, strong clinical validation data, and partnerships with major hospital networks. Investment range: $2M-$10M Series A.",
    sector: "Healthcare",
    stage: "Series A",
    investmentRange: "$2M-$10M",
    keyRequirements: ["FDA approval", "Clinical validation", "Hospital partnerships", "AI/ML technology"],
    geography: "US, Europe"
  },
  {
    id: 2,
    title: "Sustainable Energy Infrastructure",
    description: "Our fund targets renewable energy projects with proven technology and revenue generation. We seek companies working on solar, wind, or battery storage solutions with existing customer contracts and clear path to profitability. Minimum $5M ARR required. Investment: $10M-$50M growth stage.",
    sector: "Energy",
    stage: "Growth",
    investmentRange: "$10M-$50M",
    keyRequirements: ["Revenue generation", "Customer contracts", "Proven technology", "$5M+ ARR"],
    geography: "Global"
  },
  {
    id: 3,
    title: "B2B SaaS for Enterprise Automation",
    description: "We back B2B SaaS companies building enterprise automation tools with strong product-market fit. Looking for 100%+ net revenue retention, $1M+ ARR, and serving Fortune 500 customers. Our sweet spot is post-product-market-fit companies ready to scale. Seed to Series B: $500K-$15M.",
    sector: "Enterprise Software",
    stage: "Seed to Series B",
    investmentRange: "$500K-$15M",
    keyRequirements: ["100%+ NRR", "$1M+ ARR", "Fortune 500 customers", "Product-market fit"],
    geography: "North America"
  },
  {
    id: 4,
    title: "Fintech Payment Innovation",
    description: "Specializing in fintech startups revolutionizing digital payments, embedded finance, and cross-border transactions. Must have regulatory compliance, proven unit economics, and growing transaction volume. We partner with founders who have deep domain expertise in financial services. Series A-B: $5M-$25M.",
    sector: "Fintech",
    stage: "Series A-B",
    investmentRange: "$5M-$25M",
    keyRequirements: ["Regulatory compliance", "Unit economics", "Transaction growth", "Domain expertise"],
    geography: "Asia, Middle East"
  },
  {
    id: 5,
    title: "EdTech Learning Platforms",
    description: "We invest in education technology companies building scalable online learning platforms with proven student outcomes. Target market includes K-12, higher education, and professional upskilling. Looking for 50K+ active users, strong engagement metrics, and validated pedagogy. Early-stage focus: $250K-$3M.",
    sector: "Education Technology",
    stage: "Seed",
    investmentRange: "$250K-$3M",
    keyRequirements: ["50K+ users", "Student outcomes", "Engagement metrics", "Validated pedagogy"],
    geography: "India, Southeast Asia"
  }
];

export const startupIdeas = [
  {
    id: 1,
    name: "MediScan AI",
    pitch: "MediScan AI uses deep learning to detect early-stage cancer from routine blood tests with 95% accuracy. We've completed FDA breakthrough device designation and have partnerships with 15 major hospital systems across the US. Our proprietary algorithm analyzes 50+ biomarkers in minutes, reducing diagnosis time from weeks to hours.",
    sector: "Healthcare",
    stage: "Series A",
    traction: {
      revenue: "$800K ARR",
      customers: "15 hospitals",
      growth: "300% YoY",
      users: "5000+ patients processed"
    },
    team: "3 PhDs in ML, 2 MDs, ex-Google Health engineers",
    fundingNeeded: "$5M",
    useOfFunds: "FDA full approval ($2M), Sales team expansion ($1.5M), R&D ($1.5M)",
    differentiators: ["95% accuracy", "FDA breakthrough designation", "Hospital partnerships", "Proprietary ML models"]
  },
  {
    id: 2,
    name: "SolarGrid Connect",
    pitch: "SolarGrid Connect is a peer-to-peer renewable energy trading platform connecting solar panel owners with energy consumers. Our blockchain-based marketplace has processed $12M in energy trades across 5 states. We reduce energy costs by 40% for buyers and increase ROI for solar owners by 60%.",
    sector: "Energy",
    stage: "Growth",
    traction: {
      revenue: "$8M ARR",
      customers: "50K users, 200 commercial clients",
      growth: "250% YoY",
      users: "50,000+ platform users"
    },
    team: "Former Tesla energy team, blockchain developers from Coinbase",
    fundingNeeded: "$20M",
    useOfFunds: "Geographic expansion ($10M), Platform scaling ($5M), Regulatory compliance ($5M)",
    differentiators: ["Blockchain platform", "40% cost reduction", "$12M energy traded", "200 commercial clients"]
  },
  {
    id: 3,
    name: "AutoFlow Enterprise",
    pitch: "AutoFlow Enterprise automates complex business workflows for Fortune 500 companies using no-code AI. We've achieved $2.5M ARR with 120% net revenue retention across 30 enterprise customers including Microsoft, IBM, and Oracle. Our platform reduces manual work by 80% and integrates with 200+ enterprise tools.",
    sector: "Enterprise Software",
    stage: "Series A",
    traction: {
      revenue: "$2.5M ARR",
      customers: "30 Fortune 500 companies",
      growth: "400% YoY",
      users: "10,000+ enterprise users"
    },
    team: "Ex-ServiceNow engineers, former McKinsey consultants",
    fundingNeeded: "$8M",
    useOfFunds: "Product development ($3M), Sales & marketing ($3M), Customer success ($2M)",
    differentiators: ["120% NRR", "Fortune 500 customers", "80% efficiency gain", "200+ integrations"]
  },
  {
    id: 4,
    name: "PayGlobal",
    pitch: "PayGlobal enables instant cross-border payments for businesses at 90% lower fees than traditional banks. We're processing $50M monthly transaction volume across 45 countries with full regulatory compliance in each market. Our API-first approach allows seamless integration in under 24 hours.",
    sector: "Fintech",
    stage: "Series B",
    traction: {
      revenue: "$15M ARR",
      customers: "500 businesses",
      growth: "300% YoY",
      users: "$50M monthly volume"
    },
    team: "Ex-Stripe, former central bank regulators, Visa payment experts",
    fundingNeeded: "$18M",
    useOfFunds: "Regulatory expansion ($8M), Technology infrastructure ($6M), Market expansion ($4M)",
    differentiators: ["90% lower fees", "$50M monthly volume", "45 countries", "24-hour integration"]
  },
  {
    id: 5,
    name: "LearnPath Pro",
    pitch: "LearnPath Pro is an adaptive learning platform that personalizes K-12 education using AI. We have 100K active students across 200 schools with 35% improvement in standardized test scores. Our platform adapts in real-time to each student's learning pace and style, reducing teacher workload by 50%.",
    sector: "Education Technology",
    stage: "Seed",
    traction: {
      revenue: "$500K ARR",
      customers: "200 schools",
      growth: "500% YoY",
      users: "100,000 students"
    },
    team: "Former Coursera engineers, experienced K-12 educators, EdTech entrepreneurs",
    fundingNeeded: "$2M",
    useOfFunds: "Product development ($800K), Content creation ($600K), Sales & marketing ($600K)",
    differentiators: ["100K students", "35% score improvement", "AI personalization", "200 school partnerships"]
  }
];

// Helper function to get matching score expectations
export function getExpectedMatch(startup: typeof startupIdeas[0], vcUseCase: typeof vcUseCases[0]): {
  shouldMatch: boolean;
  reason: string;
  expectedScore: number; // 0-100
} {
  // Same sector
  const sectorMatch = startup.sector === vcUseCase.sector;
  
  // Stage compatibility
  const stageMatch = vcUseCase.stage.includes(startup.stage);
  
  // Funding range compatibility
  const fundingAmount = parseFloat(startup.fundingNeeded.replace(/[$M]/g, ''));
  const vcMin = parseFloat(vcUseCase.investmentRange.split('-')[0].replace(/[$M]/g, ''));
  const vcMax = parseFloat(vcUseCase.investmentRange.split('-')[1].replace(/[$M]/g, ''));
  const fundingMatch = fundingAmount >= vcMin && fundingAmount <= vcMax;
  
  if (sectorMatch && stageMatch && fundingMatch) {
    return {
      shouldMatch: true,
      reason: `Perfect match: Same sector (${startup.sector}), compatible stage (${startup.stage}), funding in range`,
      expectedScore: 85 + Math.floor(Math.random() * 15) // 85-100
    };
  } else if (sectorMatch && (stageMatch || fundingMatch)) {
    return {
      shouldMatch: true,
      reason: `Good match: Same sector, partial stage/funding fit`,
      expectedScore: 60 + Math.floor(Math.random() * 20) // 60-80
    };
  } else if (sectorMatch) {
    return {
      shouldMatch: true,
      reason: `Moderate match: Same sector but different stage or funding requirements`,
      expectedScore: 40 + Math.floor(Math.random() * 15) // 40-55
    };
  } else {
    return {
      shouldMatch: false,
      reason: `Poor match: Different sectors, unlikely fit`,
      expectedScore: 10 + Math.floor(Math.random() * 20) // 10-30
    };
  }
}

// Perfect matches for testing
export const expectedMatches = [
  { startupId: 1, vcId: 1, reason: "Healthcare AI diagnostics - perfect match" },
  { startupId: 2, vcId: 2, reason: "Renewable energy with revenue - perfect match" },
  { startupId: 3, vcId: 3, reason: "B2B SaaS with enterprise customers - perfect match" },
  { startupId: 4, vcId: 4, reason: "Fintech payments with compliance - perfect match" },
  { startupId: 5, vcId: 5, reason: "EdTech with proven outcomes - perfect match" }
];
