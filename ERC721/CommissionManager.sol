// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Abstract contract to manage commission fees for a marketplace
abstract contract CommissionManager {

    // This is the owner contract address, which receives commissions.
    // It can be changed using the transferOwnership(_ownerAddress) function.
    address payable public commissionAddress = payable(0xce41487e69B88485c6a1346C245aFb7411F163D2);

    // Constant to denote the denominator used for calculating commission percentages.
    uint32 public COMMISSION_DENOMINATOR = 10000;

    // Modifier to check if the caller is authorized.
    // This modifier should be implemented in the inheriting contract.
    modifier onlyAuthorized() virtual;

    // Function to update the commission denominator.
    // Can only be called by an authorized address.
    function updateCommissionDenominator(uint32 newDenominator) internal onlyAuthorized {
        require(newDenominator > 0, "Denominator cannot be zero");
        COMMISSION_DENOMINATOR = newDenominator;
    }

    // Function to calculate the fee based on membership status and given fee percentages.
    // Takes into account whether the user is a member or not.
    function calculateFee(bool isMember, uint256 price, uint32 userFee, uint32 memberFee) public view returns (uint256) {
        return (price * (isMember ? memberFee : userFee)) / COMMISSION_DENOMINATOR;
    }
}
