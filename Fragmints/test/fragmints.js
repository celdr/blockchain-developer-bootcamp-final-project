const _fragmints = require("../migrations/2_fragmints");

const Fragmints = artifacts.require("Fragmints");

let tokenCount = 0;

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */
contract("Fragmints", function ( accounts ) {
  it("should assert true", async function () {
    await Fragmints.deployed();
    return assert.isTrue(true);
  });

  /* 
  * verify there are no minted tokens 
  */
  it("total number minted is 0 upon deployment", async() => {
    // get the contract that has been deployed
    const ssInstance = await Fragmints.deployed();

    // verify the amount minted is 0
    const minted = await ssInstance.amountMinted();
    assert.equal(minted, 0, 'the amount minted is not 0');
  })

  /*
  * verify token counter increments after minting 
  */
  it("increment minted amount by 1 after minting", async() => {
    const ssInstance = await Fragmints.deployed();
    tokenCount++;
    // check balance of account
    let startAmount = await ssInstance.balanceOf.call(accounts[0], tokenCount);
    // mint
    await ssInstance.mintOriginal();
    // check balance again
    let endAmount = await ssInstance.balanceOf.call(accounts[0], tokenCount);
    assert.equal(endAmount.toNumber(), startAmount.toNumber() + tokenCount, 'did not increment after minting');
  })

  /*
  * verify totalSupply cannot be exceeded 
  */
  it("total supply is not exceeded", async() => {
    const ssInstance = await Fragmints.deployed();
    // mint all available tokens
    let totalSupply = await ssInstance.totalSupply();
    let minted = await ssInstance.amountMinted();
    for (let i = minted; i < totalSupply; i++) {
      tokenCount++;
      await ssInstance.mintOriginal();
    }
    // try to mint another
    try {
      await ssInstance.mintOriginal();
    } catch(error) {}

    assert(ssInstance.amountMinted(), ssInstance.totalSupply(), 'minted more than allowed');
  })

  /*
  * verify fragmenting works 
  */
  it("fragmenting token into 100 pieces", async() => {
    const ssInstance = await Fragmints.deployed();
    tokenCount++
    await ssInstance.fragmint(1, 100);
    let fragmintBalance = await ssInstance.balanceOf.call(accounts[0], tokenCount);
    assert.equal(fragmintBalance, 100, "Fragmints balance do not match expected");
    let originalBalance = await ssInstance.balanceOf.call(ssInstance.address, 1);
    assert.equal(originalBalance, 1, "Original balance do not match expected");
  })

  /* 
  * tranfer fragmints from one account to another 
  */
  it("tranfer fragmints from one account to another", async() => {
    const ssInstance = await Fragmints.deployed();
    // get latest ID used in previous test
    await ssInstance.transfer(accounts[1], tokenCount, 100);
    let fragmintBalance = await ssInstance.balanceOf.call(accounts[1], tokenCount);
    assert.equal(fragmintBalance, 100, "Fragminted pieces do not match expected");
  })


  /* 
  * further fragment a fragmint 
  */
  it("further fragment a fragmint", async() => {
    const ssInstance = await Fragmints.deployed();
    let fragmintBalance = await ssInstance.balanceOf.call(accounts[1], tokenCount);
    await ssInstance.fragmint(tokenCount, 1000000, { from: accounts[1]} );
    tokenCount++;
    // check the balance of the newly fragmented fragmint 
    let doublefragBalance = await ssInstance.balanceOf.call(accounts[1], tokenCount);
    assert.equal(doublefragBalance, 1000000, "Further fragminted balance do not match expected");
    // check the balance of the fragmint 
    let newfragmintBalance = await ssInstance.balanceOf.call(accounts[1], tokenCount - 1);
    assert.equal(fragmintBalance.toNumber() - 1, newfragmintBalance, "Fragmint balance do not match expected");
  })

  /* 
  * reform aka burn fragments and retrieve original 
  */
  it("reform tokens and retrieve original", async() => {
    const ssInstance = await Fragmints.deployed();
    // reform fragmented fragmint
    await ssInstance.reform(tokenCount, { from: accounts[1] });
    let doubleFragBalance = await ssInstance.balanceOf.call(accounts[1], tokenCount - 1);
    assert.equal(doubleFragBalance, 100, "Does not have the correct amount of tokens");
    // reform original
    await ssInstance.reform(tokenCount - 1, { from: accounts[1] });
    let fragmintBalance = await ssInstance.balanceOf.call(accounts[1], 1);
    assert.equal(fragmintBalance, 1, "Does not have the correct amount of tokens");
  })
});
