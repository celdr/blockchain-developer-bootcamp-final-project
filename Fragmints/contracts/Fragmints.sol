// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

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

  struct addrInfo {
    uint256[] open;
    uint256[] tokens;
  }

  uint256 public amountMinted;
  uint256 public totalFragmints;
  uint256 public constant totalSupply = 100;

  using Counters for Counters.Counter;
  Counters.Counter private _idCount;

  mapping(uint256 => info) public tokenInfo;
  mapping(address => addrInfo) private ownerInfo;

  event originalMinted(uint256 tokenId);
  event originalFragminted(uint256 tokenId);
  event originalReformed(uint256 tokenId);

  constructor() ERC1155("FM") {
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

    // update tokenInfo mapping
    tokenInfo[_idCount.current()].parentId = 0;
    tokenInfo[_idCount.current()].amount = 1;
    tokenInfo[_idCount.current()].ownerTokenCount[msg.sender]++;

    // update ownerInfo mapping
    ownerInfo[msg.sender].tokens.push(_idCount.current());

    amountMinted++;

    _mint(msg.sender, _idCount.current(), 1, "");

    emit originalMinted(_idCount.current());

    return _idCount.current();
  }

  function fragmint(uint _tokenId, uint _pieces) public returns (uint) {
    require(tokenInfo[_tokenId].ownerTokenCount[msg.sender] > 0);
    require(ownerInfo[msg.sender].tokens.length != 0);

    _idCount.increment();

    // update ownerInfo mapping
    // for sender
    if (tokenInfo[_tokenId].ownerTokenCount[msg.sender] == 1) {
      uint256 index = getIdIndex(msg.sender, _tokenId);
      delete ownerInfo[msg.sender].tokens[index];
      ownerInfo[msg.sender].open.push(index);
    }
    ownerInfo[msg.sender].tokens.push(_idCount.current());
    // for contract
    if (tokenInfo[_tokenId].ownerTokenCount[address(this)] < 1) { // doesn't have id
      if (ownerInfo[address(this)].open.length != 0) {
        uint256 index = popWithValue(address(this));
        ownerInfo[address(this)].tokens[index] = _tokenId;
      } else {
        ownerInfo[address(this)].tokens.push(_tokenId);
      }
    } 
  
    // update tokenInfo mapping
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
    require(tokenInfo[_tokenId].ownerTokenCount[msg.sender] == numPieces);   
    require(parentId != 0);
    require(ownerInfo[msg.sender].tokens.length != 0);


    // update ownerInfo mapping
    // for sender
    uint256 index = getIdIndex(msg.sender, _tokenId);
    delete ownerInfo[msg.sender].tokens[index];
    if (tokenInfo[parentId].ownerTokenCount[msg.sender] > 0) { 
      ownerInfo[msg.sender].open.push(index);
    } else {
      ownerInfo[msg.sender].tokens[index] = parentId;
    }
    // for contract
    if (tokenInfo[parentId].ownerTokenCount[address(this)] == 1) {
      index = getIdIndex(address(this), parentId);
      delete ownerInfo[address(this)].tokens[index];
      ownerInfo[address(this)].open.push(index);
    }

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
    require(_amount <= tokenInfo[_tokenId].amount);
    require(_amount <= tokenInfo[_tokenId].ownerTokenCount[msg.sender]);

    // update ownerInfo mapping
    if (tokenInfo[_tokenId].ownerTokenCount[msg.sender] == _amount) {
      uint256 index = getIdIndex(msg.sender, _tokenId);
      delete ownerInfo[msg.sender].tokens[index];
      ownerInfo[msg.sender].open.push(index);
    }

    if (tokenInfo[_tokenId].ownerTokenCount[_to] == 0) {
      if(ownerInfo[_to].open.length != 0) {
        uint256 index = popWithValue(_to);
        ownerInfo[_to].tokens[index] = _tokenId;
      } else {
        ownerInfo[_to].tokens.push(_tokenId);
      }
    }

    // update tokenInfo mapping
    if (tokenInfo[_tokenId].ownerTokenCount[msg.sender] == _amount) {
      delete tokenInfo[_tokenId].ownerTokenCount[msg.sender];
    } else {
      tokenInfo[_tokenId].ownerTokenCount[msg.sender] -= _amount;
    }
    
    tokenInfo[_tokenId].ownerTokenCount[_to] += _amount;
    _safeTransferFrom(msg.sender, _to, _tokenId, _amount, "");
  }

  function getAddrToken() public view returns (uint256[] memory) {
    return ownerInfo[msg.sender].tokens;
  }

  // internal helper functions
  function getIdIndex(address _addr, uint256 _id) internal view returns (uint256) {
    uint256[] storage tokens = ownerInfo[_addr].tokens;
    uint256 i = 0;
    for(i = 0; i < tokens.length; i++) {
      if (tokens[i] == _id) {
        break;
      }
    }
    
    return i;
  }

  function popWithValue(address _addr) internal returns (uint256) {
    uint256[] storage openIndex = ownerInfo[_addr].open;
    uint256 len = openIndex.length;
    uint256 val = openIndex[len - 1];
    openIndex.pop();
    return val;
  }
} 
