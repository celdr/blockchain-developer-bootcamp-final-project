// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Fragmints is ERC1155, ERC1155Holder, AccessControl {
  struct info {
    uint256 parentId;
    uint256 amount;
    mapping(address => uint) ownerTokenCount;
  }

  uint256 public amountMinted;
  uint256 public totalFragmints;
  uint256 public constant totalSupply = 50;

  using Counters for Counters.Counter;
  Counters.Counter private _idCount;

  mapping(uint256 => info) public tokenInfo;

  event originalMinted(uint256 tokenId);
  event originalFragminted(uint256 tokenId);
  event originalReformed(uint256 tokenId);

  constructor() ERC1155("") {
    amountMinted = 0;
    totalFragmints = 0;
  }

  // override 
  function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl, ERC1155Receiver) returns (bool) {
      return super.supportsInterface(interfaceId);
  }

  function mintOriginal() public returns (uint256) {
    require(amountMinted < totalSupply);
    _idCount.increment();

    // update mapping
    tokenInfo[_idCount.current()].parentId = 0;
    tokenInfo[_idCount.current()].amount = 1;
    tokenInfo[_idCount.current()].ownerTokenCount[msg.sender]++;
    amountMinted++;

    _mint(msg.sender, _idCount.current(), 1, "");

    emit originalMinted(_idCount.current());

    return _idCount.current();
  }

  function fragmint(uint _tokenId, uint _pieces) public returns (uint) {
    require(tokenInfo[_tokenId].ownerTokenCount[msg.sender] != 0);

    _idCount.increment();

    // update mapping
    if (tokenInfo[_tokenId].ownerTokenCount[msg.sender] > 1) {
      tokenInfo[_tokenId].ownerTokenCount[msg.sender]--;
    } else {
      delete tokenInfo[_tokenId].ownerTokenCount[msg.sender];
    }
    tokenInfo[_tokenId].ownerTokenCount[address(this)]++;
    tokenInfo[_idCount.current()].parentId = _tokenId;
    tokenInfo[_idCount.current()].amount = _pieces; 
    tokenInfo[_idCount.current()].ownerTokenCount[msg.sender] = _pieces;

    // update fragmint amount
    totalFragmints += _pieces;

    // transfer token to contract
    _safeTransferFrom(msg.sender, address(this), _tokenId, 1, "");

    // mint fragmints
    _mint(msg.sender, _idCount.current(), _pieces, "");
  
    emit originalFragminted(_idCount.current());

    return _idCount.current();
  }

  function reform(uint _tokenId) public returns (uint) {
    uint256 parentId = tokenInfo[_tokenId].parentId;
    uint256 numPieces = tokenInfo[_tokenId].amount;

    // require msg.sender have all the pieces
    require(tokenInfo[_tokenId].ownerTokenCount[msg.sender] == tokenInfo[_tokenId].amount);   

    // update mapping
    delete tokenInfo[_tokenId];
    if (tokenInfo[parentId].ownerTokenCount[address(this)] > 1) {
      tokenInfo[parentId].ownerTokenCount[address(this)]--;
    } else {
      delete tokenInfo[parentId].ownerTokenCount[address(this)];
    }
    tokenInfo[parentId].ownerTokenCount[msg.sender]++;

    totalFragmints -= numPieces;

    // burn pieces
    _burn(msg.sender, _tokenId, numPieces);

    // transfer original to msg.sender
    _safeTransferFrom(address(this), msg.sender, parentId, 1, "");

    emit originalReformed(parentId);

    return parentId;
  }

  function transfer(address _to, uint _tokenId, uint _amount) public {
    require(tokenInfo[_tokenId].amount <= _amount);
    require(tokenInfo[_tokenId].ownerTokenCount[msg.sender] <= _amount);

    if (tokenInfo[_tokenId].ownerTokenCount[msg.sender] == _amount) {
      delete tokenInfo[_tokenId].ownerTokenCount[msg.sender];
    } else {
      tokenInfo[_tokenId].ownerTokenCount[msg.sender] -= _amount;
    }
    
    tokenInfo[_tokenId].ownerTokenCount[_to] += _amount;
    _safeTransferFrom(msg.sender, _to, _tokenId, _amount, "");
  }
} 
