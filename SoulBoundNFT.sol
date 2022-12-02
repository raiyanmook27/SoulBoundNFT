
// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";


/// @title A Soulbound NFt
/// @author Raiyan Mukhtar
/// @dev Minted Nfts are bound to the minter and are not transferable.
contract SoulBoundNFT is ERC721Pausable,Ownable{
    using Counters for Counters.Counter; 
    uint256 constant totalSupply = 100;
    Counters.Counter tokenId;
    uint256 constant minAmount= 0.0002 ether;


    
    constructor ()  ERC721("SoulBound","SB"){}


    /// @notice before transfer of tokens it checks if paused
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal virtual whenNotPaused override {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);

    }

    /**
    * @notice Mint nfts
    * @dev The sets pause value to true: so the nft cant be transfered
    *
    **/
    function mintNft() public  payable returns(Counters.Counter memory){

        if(paused()){
            _unpause();
        }
        require(msg.sender!=address(0),"Zero address");
        require(msg.value>minAmount,"Not Enough eth");
        require(tokenId._value <totalSupply,"All Nfts minted");

        tokenId.increment();

        _safeMint(msg.sender, tokenId._value);
        
        _pause();

        return tokenId;
    } 

    function withdraw() external onlyOwner {
        require(msg.sender!=address(0),"Address invalid");
        address _owner = owner();
        uint256 amount = address(this).balance;
        (bool sent, ) = _owner.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }

}
