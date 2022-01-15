# Design Pattern Decisions

## Inheritance and Interfaces

The Fragmints contract inherits ERC1155.sol, ERC1155Holder.sol, and AccessControl.sol from OpenZeppelin.

## Upgradable Contract

A function is available to the contract owner to update the URI for all tokens.

## Access Control Design Pattern

OpenZeppelin's Ownable is used to allow the owner of the contract to set the URI.