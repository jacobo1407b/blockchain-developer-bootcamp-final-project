const AssetT = artifacts.require('AssetT');

let instance;

beforeEach(async () => {
    instance = await AssetT.new();
});

contract('AssetT', (accounts) => {

    it('should pay a property', async () => {
        await instance.registerUser('123', {
            from: accounts[0],
            gas: 3000000
        });
        await instance.emitRegisterProperty('123', '123', '123', 20, {
            from: accounts[0],
            gas: 3000000
        });

        let owner = await instance.payProperty(1, '123456', accounts[0],{
            from: accounts[1],
            gas: 3000000,
            value: 200000000000000000
        });

        /*let resp = await instance.getIdProperty(1,{
            from: accounts[1],
            gas: 3000000
        });*/
        assert.equal(owner.receipt.status, true);
    });
});