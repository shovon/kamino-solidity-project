import { expect } from "chai";

describe("TokenFactory", function () {
  let TokenFactory, tokenFactory, owner, addr1;

  beforeEach(async function () {
    TokenFactory = await ethers.getContractFactory("TokenFactory");
    [owner, addr1] = await ethers.getSigners();
    tokenFactory = await TokenFactory.deploy();
    await tokenFactory.deployed();
  });

  it("Should create a new token", async function () {
    const tx = await tokenFactory.createToken("TestToken", "TTK");
    const receipt = await tx.wait();

    const event = receipt.events.find(
      (event) => event.event === "TokenCreated"
    );
    const [tokenAddress, name, symbol, creator] = event.args;

    expect(name).to.equal("TestToken");
    expect(symbol).to.equal("TTK");
    expect(creator).to.equal(owner.address);
  });

  it("Should return all created tokens", async function () {
    await tokenFactory.createToken("TestToken1", "TTK1");
    await tokenFactory.createToken("TestToken2", "TTK2");

    const tokens = await tokenFactory.getAllTokens();
    expect(tokens.length).to.equal(2);
  });

  it("Should return tokens created by a specific creator", async function () {
    await tokenFactory.createToken("TestToken1", "TTK1");
    await tokenFactory.connect(addr1).createToken("TestToken2", "TTK2");

    const ownerTokens = await tokenFactory.getTokensByCreator(owner.address);
    const addr1Tokens = await tokenFactory.getTokensByCreator(addr1.address);

    expect(ownerTokens.length).to.equal(1);
    expect(addr1Tokens.length).to.equal(1);
  });

  it("Should deploy CustomToken with correct parameters", async function () {
    const tx = await tokenFactory.createToken("TestToken", "TTK");
    const receipt = await tx.wait();

    // Get the CustomToken address from the event
    const event = receipt.events.find(
      (event) => event.event === "TokenCreated"
    );
    const [tokenAddress] = event.args;

    // Create a contract instance for the newly deployed CustomToken
    const CustomToken = await ethers.getContractFactory("CustomToken");
    const tokenInstance = CustomToken.attach(tokenAddress);

    // Verify the token parameters
    expect(await tokenInstance.name()).to.equal("TestToken");
    expect(await tokenInstance.symbol()).to.equal("TTK");
    expect(await tokenInstance.owner()).to.equal(owner.address);
  });
});
