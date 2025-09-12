# 🌈 MoodMarket - The Emotional Economy Protocol

> Building the world's first emotional GDP on-chain 💝

## 🎯 Overview

MoodMarket transforms emotional wellbeing into a measurable, tradeable, and valuable asset. Users anonymously log moods via Soulbound NFTs while earning Empathy Tokens that power a supportive community economy.

## ✨ Core Features

### 📊 Mood Logging System
- **Anonymous Soulbound NFTs** for privacy-first mood tracking
- **10-point mood scale** (1=very negative, 10=very positive)
- **Automatic rewards** in Empathy Tokens for participation

### 🌤️ Emotional Weather
- **Real-time community mood index** calculated from daily averages
- **Dynamic pricing** of emotional states based on collective data
- **Weather alerts** for community mental health support

### 🤝 Support Economy
- **Empathy Token rewards** for positive mood logging
- **Peer-to-peer support** through token transfers
- **Reputation system** for community helpers

### 📈 Emotional GDP
- **First-ever on-chain emotional economy metrics**
- **Community health dashboards**
- **Data-driven insights** for workplace culture and mental health

## 🚀 Quick Start

### Deploy Contract
```bash
clarinet console
::deploy_contract contracts/MoodMarket---The-Emotional-Economy-Protocol.clar
```

### Log Your Mood
```clarity
(contract-call? .MoodMarket---The-Emotional-Economy-Protocol log-mood u7 0x1234...)
```

### Give Support
```clarity
(contract-call? .MoodMarket---The-Emotional-Economy-Protocol give-support 'SP1ABC... u5)
```

### Check Emotional Weather
```clarity
(contract-call? .MoodMarket---The-Emotional-Economy-Protocol get-emotional-weather)
```

## 📖 Usage Guide

### 🎭 For Users
1. **Log Daily Mood**: Score 1-10 with anonymous buffer ID
2. **Earn Empathy Tokens**: Higher rewards for vulnerability (low moods get 15 tokens vs 10 for high moods)
3. **Support Others**: Transfer tokens to community members
4. **Build Reputation**: Give and receive support to increase standing

### 🏢 For Organizations
1. **Monitor Team Health**: Track emotional weather trends
2. **Identify Support Needs**: Automated alerts for low community mood
3. **Reward Empathy**: Batch reward system for supportive team members
4. **Measure Culture**: Quantify workplace emotional environment

### 📊 Key Metrics
- **Emotional Weather Index**: Daily average mood (1-10)
- **Participation Rate**: Active users logging moods
- **Positivity Ratio**: Percentage of positive mood logs
- **Support Activity**: Empathy token circulation
- **Community Health Score**: Composite wellness metric

## 🔧 Contract Functions

### Public Functions
- `log-mood(mood-score, anonymous-id)` - Record mood and mint NFT
- `give-support(recipient, empathy-amount)` - Transfer empathy tokens
- `create-community-mood-session(session-reward)` - Emergency support session

### Read-Only Functions
- `get-emotional-weather()` - Current community mood index
- `get-emotional-gdp()` - Complete economy metrics
- `get-community-health()` - Health dashboard data
- `get-user-mood(user)` - Individual user mood data
- `get-empathy-balance(user)` - Token balance

## 🎪 Use Cases

### 💼 Workplace Culture
- **Remote team mood tracking**
- **Burnout prevention alerts**
- **Empathy-driven performance reviews**

### 🏥 Mental Health Support
- **Anonymous community support networks**
- **Peer counseling incentives**
- **Emotional wellness gamification**

### 🎨 Creative Communities
- **Artist collective mood sharing**
- **Collaborative emotional expression**
- **Mood-based creative challenges**

## 🔐 Privacy & Security

- **Soulbound NFTs** prevent mood data trading
- **Anonymous IDs** protect user identity
- **On-chain transparency** with privacy preservation
- **Community-owned** emotional data

## 🌱 Roadmap

- [ ] Mobile mood logging app
- [ ] Integration with wearable devices
- [ ] AI-powered mood pattern analysis
- [ ] Cross-platform emotional data portability
- [ ] Therapeutic intervention triggers

## 🤝 Contributing

We're building the future of emotional economics together! 

- **Report bugs** and suggest features
- **Submit mood logging patterns** for analysis
- **Propose governance improvements**
- **Build applications** on top of MoodMarket

---

*"In a world where emotions are data, empathy becomes currency."* 💫

Built with ❤️ using Clarity and Stacks blockchain
