// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Fragmint {

  struct info {
    address originalOwner; 
    address currentOwner;
    uint originalTokenId;
    uint numOfPieces;
    // uint price;
  }

  // This will track the original NFT token ID and pair them with all the generated pieces
  mapping(uint => uint[]) private originalToFragments; 
  mapping(uint => info) private fragmentInfo;
  mapping(address => uint) internal fragmentCount;
  mapping(uint => address) internal idToOwner;

  event itemFragmented(uint[] tokenIds);
  event itemReformed(uint tokenId);
  event itemTransferred(uint tokenId);

  modifier isFragmented(uint tokenId) {
    //// Checks that NFT is fragmented piece of an NFT
  }

  modifier holdAllPieces(uint[] memory fragmentIds) {
    //// Hold all the fragmented pieces of original NFT
  }
  constructor() public {
    owner = msg.sender;
  }

  function fragment(uint tokenId, uint amount) public {

    //// Transfer tokenId to contract address

    //// Mint/transfer 'amount' of NFTs back to owner 

    //// Update originalToPieces mapping using tokenId

    //// Update fragmentInfo for each fragmented token ID

    //// Update fragmentCount for msg.sender

    //// Emit Event
    // emit itemFragmented(newTokens);
  }

  function reform(uint[] memory fragmentIds) public holdAllPieces(fragmentIds) {
    //// Verify all fragments are counted for

    //// If verified, burn fragments

    //// Transfer original NFT back to msg.sender
    // _retreiveOriginal(originalId, msg.sender);

    //// Delete item from mappings
    // delete originalToFragments[originalId];
    // for(uint i)

    //// Emit event
    // emit itemReformed();
  }

  /* Private function that sends the original back to msg.sender (if they have all the pieces) */
  function _retreiveOriginal(uint tokenId, address reformer) private holdAllPieces(tokenId) {
    
  }

  function getInfo(uint tokenId) public view isFragmented(tokenId) returns(address, uint, uint) {
    //// get information/history about a fragmented NFT
    // return (fragmentInfo[tokenId].originalOwner, fragmentInfo[tokenId].originalTokenId, fragmentInfo[tokenId].numOfPieces);
  }

  /* Allow user to send NFTs through interface on page */
  function transfer(address _dest, uint _tokenId) public {
    //// Require msg.sender owns token
    // require(msg.sender == idToOwner[tokenId]);
    //// Change owners
    // idToOwner[_tokenId] = _dest;
    //// Emit event
    // emit itemTransferred(_tokenId);
  }

}