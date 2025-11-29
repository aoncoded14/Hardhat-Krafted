# OccasionTicketing - Decentralized Event Ticketing System

[![Solidity](https://img.shields.io/badge/Solidity-0.8.x-blue.svg)](https://soliditylang.org/)
[![Hardhat](https://img.shields.io/badge/Built%20with-Hardhat-yellow.svg)](https://hardhat.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A decentralized event ticketing platform built on Ethereum that allows users to create occasions, sell tickets, and manage events with complete transparency and security.

## 🌟 Features

- **Multi-Type Occasions**: Support for General, VIP, and Multiple Category events
- **Secure Ticket Management**: Immutable ticket ownership on the blockchain
- **Transparent Fundraising**: Real-time tracking of funds raised for each occasion
- **Flexible Ticket Types**: Different ticket categories with varying privileges
- **Deadline Enforcement**: Automatic cut-off for ticket sales
- **Withdrawal Security**: Secure fund release to event hosts

## 📋 Smart Contract Overview

### Core Structures

```solidity
struct OccasionDetail {
    uint256 occasionId;
    address host;
    uint256 goal;
    uint256 deadline;
    uint256 amountRaised;
    bool isWithdrawn;
    uint256 totalTicketsSold;
    TicketType occasionType;
}

struct TicketDetail {
    uint256 ticketId;
    uint256 occasionId;
    address attendee;
    uint256 price;
    uint256 timestamp;
    bool held;
    TicketType ticketType;
}

enum TicketType { General, VIP, Premium }