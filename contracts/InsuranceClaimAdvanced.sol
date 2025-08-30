// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract InsuranceClaimAdvanced is Ownable {

    IERC20 public payoutToken;

    enum Status { Pending, Approved, Rejected }

    struct Claim {
        address claimant;
        string description;
        uint256 amount;
        Status status;
        bool paid;
    }

    mapping(uint256 => Claim) public claims;
    mapping(address => bool) public registeredUsers;
    uint256 public claimCount;

    event UserRegistered(address indexed user);
    event ClaimSubmitted(uint256 indexed claimId, address indexed claimant);
    event ClaimApproved(uint256 indexed claimId);
    event ClaimRejected(uint256 indexed claimId);
    event ClaimPaid(uint256 indexed claimId, address indexed claimant, uint256 amount);

    constructor(address _payoutToken) {
        payoutToken = IERC20(_payoutToken);
    }

    // Register a user
    function registerUser() public {
        require(!registeredUsers[msg.sender], "Already registered");
        registeredUsers[msg.sender] = true;
        emit UserRegistered(msg.sender);
    }

    // Submit a claim
    function submitClaim(string memory _description, uint256 _amount) public {
        require(registeredUsers[msg.sender], "Register first");
        claimCount++;
        claims[claimCount] = Claim(msg.sender, _description, _amount, Status.Pending, false);
        emit ClaimSubmitted(claimCount, msg.sender);
    }

    // Approve claim (only owner/admin)
    function approveClaim(uint256 _id) public onlyOwner {
        require(claims[_id].status == Status.Pending, "Already processed");
        claims[_id].status = Status.Approved;
        emit ClaimApproved(_id);
    }

    // Reject claim (only owner/admin)
    function rejectClaim(uint256 _id) public onlyOwner {
        require(claims[_id].status == Status.Pending, "Already processed");
        claims[_id].status = Status.Rejected;
        emit ClaimRejected(_id);
    }

    // Pay approved claim
    function payClaim(uint256 _id) public onlyOwner {
        Claim storage c = claims[_id];
        require(c.status == Status.Approved, "Claim not approved");
        require(!c.paid, "Already paid");

        c.paid = true;
        payoutToken.transfer(c.claimant, c.amount);
        emit ClaimPaid(_id, c.claimant, c.amount);
    }

    // View claim
    function getClaim(uint256 _id) public view returns (
        address, string memory, uint256, string memory, bool
    ) {
        Claim memory c = claims[_id];
        string memory statusText = c.status == Status.Pending ? "Pending" :
                                   c.status == Status.Approved ? "Approved" : "Rejected";
        return (c.claimant, c.description, c.amount, statusText, c.paid);
    }
}
