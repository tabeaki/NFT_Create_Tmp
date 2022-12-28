// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
//import "hardhat/console.sol"; // Hardhat console log

import './ERC721A.sol';
import "./node_modules/@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SmartGenerative
 * @notice Mint Generative NFT (add RRC721A and WL's MerkleProof)
 */
contract TORIIPROJECT is ERC721A, Ownable {

    string baseURI;
    string public baseExtension = ".json";
    uint256 public cost = 0.25 ether;
    uint256 public maxSupply = 4;
    uint256 public maxMintAmount = 5;
    bool public paused = true;

    constructor(
    ) ERC721A('ETH MASKS', 'EM') {
        setBaseURI('');
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /**
    * @notice Mint from mint site
    */
    function mint() public payable {
        require(!paused, "the contract is paused");
        uint256 supply = totalSupply();
        require(supply + 1 <= maxSupply, "max NFT limit exceeded");

        // Owner also can mint.
        if (msg.sender != owner()) {
            require(msg.value >= cost , "insufficient funds");
        }

        _safeMint(msg.sender, 1);
    }

    /**
    * @notice Use for airdrop
    * @param _airdropAddresses Airdrop address array
    * @param _UserMintAmount Airdrop amount of mint array
    * @dev onlyOwner
    */
    function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public onlyOwner{
        uint256 supply = totalSupply();
        uint256 _mintAmount = 0;
        for (uint256 i = 0; i < _UserMintAmount.length; i++) {
            _mintAmount += _UserMintAmount[i];
        }
        require(_mintAmount > 0, "need to mint at least 1 NFT");
        require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

        for (uint256 i = 0; i < _UserMintAmount.length; i++) {
            _safeMint(_airdropAddresses[i], _UserMintAmount[i] );
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory){
        return string(abi.encodePacked(ERC721A.tokenURI(tokenId), baseExtension));
    }

    function is_paused() public view returns(bool){
        return paused;
    }

    //only owner  
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }   

    function getMaxSupply() public view onlyOwner returns(uint256){
        return maxSupply;
    }

    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
        maxMintAmount = _newmaxMintAmount;
    }
  
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
        baseExtension = _newBaseExtension;
    }

    function pause(bool _state) public onlyOwner {
        paused = _state;
    }

    function setMaxSupply(uint256 _amount) public onlyOwner {
        maxSupply = _amount;
    }
 
    function withdraw() public payable onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
    }

     /**
    * @notice ERC721A override
    * @return uint256 Return index at 1
    * @dev Changed because ERC721A returns index 0
    */
    function _startTokenId() internal view virtual override returns (uint256) {
        return 1;
    }    
}
