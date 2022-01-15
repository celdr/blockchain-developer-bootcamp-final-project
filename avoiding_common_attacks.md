# Avoiding Common Attacks

## Lock Pragma Version (SWC-103)

Using a specific pragma version that was set when tested reduces the chance of introducing errors from an outdated compiler.

```
pragma solidity ^0.8.0;
```

## Re-entry Protection (SWC-107)

Updating statuses and record before actually sending tokens protect from re-entry attacks.


```
amountMinted++;
_mint(msg.sender, _idCount.current(), 1, "");
```

## Use of Require (SWC-123)

Using require at the start of function to revert invalid calls.

```
require(tokenInfo[_tokenId].ownerTokenCount[msg.sender] != 0);
```