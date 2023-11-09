// SPDX-License-Identifier: MIT
pragma  solidity ^0.8.0;

contract PropertyManagement {

    struct Property {
        address owner;
        address tenant;
        uint256 rent;
        uint256 leaseStart;
        uint256 leaseEnd;
    }

    mapping(address => Property) public properties;

    function createProperty(address owner, uint256 rent) public {
        require(owner != address(0), "Invalid owner address");
        require(rent > 0, "Invalid rent amount");

        properties[owner] = Property({
            owner: owner,
            tenant: address(0),
            rent: rent,
            leaseStart: 0,
            leaseEnd: 0
        });
    }

    function leaseProperty(address owner, address tenant) public {
        require(properties[owner].tenant == address(0), "Property is already leased");
        require(tenant != address(0), "Invalid tenant address");

        properties[owner].tenant = tenant;
        properties[owner].leaseStart = block.timestamp;
        properties[owner].leaseEnd = block.timestamp + 365 days;
    }

    function payRent(address owner) public payable {
        require(properties[owner].tenant != address(0), "Property is not leased");
        require(msg.value >= properties[owner].rent, "Insufficient rent payment");

        // Transfer the rent to the owner
        (bool success, ) = payable(properties[owner].owner).call{value: msg.value}("");
        require(success, "Rent payment failed");
    }

    function evictTenant(address owner) public {
        require(properties[owner].tenant != address(0), "Property is not leased");

        // Set the tenant to the null address
        properties[owner].tenant = address(0);
    }
}
