// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;
//import "hardhat/console.sol"; // Hardhat console log

import "./ERC721A.sol";
import "./Ownable.sol";

/**
 * @title SmartGenerative
 * @notice Mint Generative NFT (add RRC721A and WL's MerkleProof)
 */
contract TokenMaksLabs is ERC721A, Ownable {
    
    // NFTの情報をコントラクトから見にいくURL
    string baseURI;
    // baseURIが見にいくURLのファイルの拡張子
    string public baseExtension = ".json";
    // NFTの値段
    uint public cost = 0.1 ether;
    // 最大発行数
    uint public maxSupply = 5000;
    // 一回のMax購入数
    uint public maxMintAmount = 5;
    // saleの開始を制御する関数
    bool public paused = true;
    

    constructor(
    ) ERC721A('ETH MASKS', 'EM') {// NFTのコレクション名：ETH MASKS 、トークン名：EM に設定
        // BaseURIを最初に設定しておく
        setBaseURI('');
    }

    // internal 現在設定されているURIを返却する
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    /**
    * @notice NFTを発行する為の関数
    */
    function mint(uint256 _mintAmount) public payable {
        // pausedの値によってmintをさせないようにする。
        if(paused) revert("the contract is paused");
        // ERC721のtotalSupply()関数は現在の発行数を取得できるので、現在の発行数をsupply変数へ入れる
        uint256 supply = totalSupply();
        // 引数が０より大きいことを確認し、０以下の場合はエラーを返却
        if(!(_mintAmount > 0)) revert("Please specify 1 or more");
        // 一度に発行できる数のmaxMintAmountより、発行しようとしている数の_mintAmountが大きくないことを確認
        if(_mintAmount > maxMintAmount) revert("max mint amount per session exceeded");
        // 最大発行数より、今回発行する枚数+現在発行されている枚数が大きくなっていないことを確認
        if(supply + _mintAmount > maxSupply) revert("max NFT limit exceeded");

        // コントラクトのオーナーは実行されない
        if (msg.sender != owner()) {
            // msg.valueはmint関数を呼び出す時にユーザが送ったETHの数
            // mint関数を呼び出したaddressが、枚数*costの値段を支払っているか確認
            if(msg.value < cost * _mintAmount) revert("insufficient funds");
        }

        // NFTを発行できる関数をERC721から呼ぶ、引数：msg.sender（mint関数実行のaddress),_mintAmountはNFTの発行する数
        _safeMint(msg.sender, _mintAmount);
    }

    /**
    * @notice NFTを特定のウォレットに対して発行してあげる関数
    * @param _airdropAddresses Airdrop address array
    * @param _UserMintAmount Airdrop amount of mint array
    * @dev onlyOwner
    */
    function airdropMint(address[] calldata _airdropAddresses , uint256[] memory _UserMintAmount) public onlyOwner{
        // ERC721のtotalSupply()関数は現在の発行数を取得できるので、現在の発行数をsupply変数へ入れる
        uint256 supply = totalSupply();
        // 発行するNFTの数を格納する変数を設定
        uint256 _mintAmount = 0;
        // Arrayに格納されている、発行数をすべてプラスする
        for (uint256 i = 0; i < _UserMintAmount.length; i++) {
            _mintAmount += _UserMintAmount[i];
        }
        // 発行数が０以下でないことを確認
        if(!(_mintAmount > 0)) revert("Please specify 1 or more");
        // 最大発行数より、今回発行する枚数+現在発行されている枚数が大きくなっていないことを確認
        if(supply + _mintAmount > maxSupply) revert("max NFT limit exceeded");

        // エアドロ（無料で配布すること）するアドレスと発行数枚数を一つ一つペアで_safeMintへ渡す
        for (uint256 i = 0; i < _UserMintAmount.length; i++) {
            _safeMint(_airdropAddresses[i], _UserMintAmount[i] );
        }
    }
    // abi.encodePackedは文字列を結合する関数「ERC721A.tokenURI(tokenId)とbaseExtensionを組み合わせて、トークンIDに紐づくURIを返却する
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
