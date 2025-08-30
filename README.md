#Blockchain Insurance Claim System

## Overview
This project is a **high-level blockchain-based insurance claim system** built with Solidity and tested on Remix VM.  
It allows **user registration, claim submission, admin approval/rejection, and token-based payouts**.

## Features
- **User Registration**: Users must register to submit claims.  
- **Submit Claim**: Registered users can submit claims with description and token amount.  
- **Admin Panel**: Owner/admin can approve, reject, and pay claims.  
- **Token Payout**: Approved claims can be paid using ERC20 tokens.  
- **Event Logging**: Every action emits an event for easy tracking.  

## Smart Contract
- Contract: `InsuranceClaimAdvanced.sol`  
- Roles: User (claimant), Admin/Owner  
- Enum `Status`: Pending, Approved, Rejected  
- Functions:  
  - `registerUser()`  
  - `submitClaim(string memory, uint256)`  
  - `approveClaim(uint256)`  
  - `rejectClaim(uint256)`  
  - `payClaim(uint256)`  
  - `getClaim(uint256)`  

## Frontend
- HTML + JavaScript frontend using **ethers.js**  
- Features registration, claim submission, claim viewing, and admin actions.  
- Simple, clean UI with responsive buttons and input fields.  

## Project Structure
