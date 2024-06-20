// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract NFTValue {
    mapping(uint256 => uint256) private nftValues;
    ZKProof private zkProof;

    // Constructor to initialize the ZKProof contract
    constructor(address zkProofAddress) {
        zkProof = ZKProof(zkProofAddress);
    }

    // Function to set the value of an NFT
    function setNFTValue(uint256 tokenId, uint256 value) public {
        nftValues[tokenId] = value;
    }

    // Function to get the value of an NFT (for internal use)
    function getNFTValue(uint256 tokenId) internal view returns (uint256) {
        return nftValues[tokenId];
    }

    // Function to generate a zero-knowledge proof
    function generateProof(uint256 tokenId, uint256 minValue, uint256 maxValue) public view returns (bytes memory) {
        uint256 value = getNFTValue(tokenId);
        require(value >= minValue && value <= maxValue, "Value not within range");
        return zkProof.generate(tokenId, value, minValue, maxValue);
    }

    // Function to verify a zero-knowledge proof
    function verifyProof(bytes memory proof, uint256 minValue, uint256 maxValue) public view returns (bool) {
        return zkProof.verify(proof, minValue, maxValue);
    }
}

// Interface for the ZKProof contract
interface ZKProof {
    function generate(uint256 tokenId, uint256 value, uint256 minValue, uint256 maxValue) external view returns (bytes memory);
    function verify(bytes memory proof, uint256 minValue, uint256 maxValue) external view returns (bool);
}

