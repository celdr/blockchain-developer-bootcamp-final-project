# Avoiding Common Attacks

## Lock Pragma Version

Using a specific pragma version that was set when tested reduces the chance of introducing errors from an outdated compiler.

```
pragma solidity ^0.8.0;
```

## Re-entry Protection

Updating statuses and record before actually sending tokens protect from re-entry attacks.


```
amountMinted++;
_mint(msg.sender, _idCount.current(), 1, "");
```

## Use of Require

Using require at the start of function to revert invalid calls.

```
require(tokenInfo[_tokenId].ownerTokenCount[msg.sender] != 0);
```