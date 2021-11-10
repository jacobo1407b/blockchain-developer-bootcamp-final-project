const AssetT = artifacts.require('AssetT');

let instance;

beforeEach(async () => {
  instance = await AssetT.new();
});

contract('AssetT', (accounts) => {
    it('should register a new user', async () => {
        let owner = await instance.registerUser('12345',{
            from: accounts[0],
            gas: 3000000
        });
        console.log(owner);
        assert.equal(owner, accounts[0]);
    });
})