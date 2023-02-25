export const setting = {
    CONTRACT_ADDRESS: "0x93756c4cB5D8974959507F5Fc70A800a9b63e3a3",
    CAHINID: '0x5',
    DECIMALS: 1,
    CHAIN_NAME: 'ETH',
    COIN_NAME: 'ETH',
    RPC_URLS: "https://Goerli.infura.io/v3/d9a8d8a693da47db8cc8397ff08f9021",
    TOKEN_PRICE: '0.001',
    ABI: [
        'function totalSupply() public view virtual override returns (uint256)',
        'function preMint(uint _mintAmount, bytes32[] memory _merkleProof, uint alloc) public payable',
    ],
}