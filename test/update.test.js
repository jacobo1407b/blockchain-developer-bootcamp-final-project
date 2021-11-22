
const AssetT = artifacts.require('AssetT');

let instance;

beforeEach(async () => {
    instance = await AssetT.new();
});

contract('AssetT', (accounts) => {
    it('should change visible of property', async () => {
        await instance.registerUser('12345', {
            from: accounts[0],
            gas: 3000000
        });
        await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
            from: accounts[0],
            gas: 3000000
        });
        let property = await instance.onVisible(true,1, {
            from: accounts[0],
            gas: 3000000
        });
        assert.equal(property.receipt.status, true);
    });

    it('should not change visible of property', async () => {
        let err = null;
        try {
            await instance.registerUser('12345', {
                from: accounts[0],
                gas: 3000000
            });
            await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
                from: accounts[0],
                gas: 3000000
            });
            await instance.onVisible(true,1, {
                from: accounts[1],
                gas: 3000000
            });
        } catch (error) {
            err = error.message;
        }
        assert.equal(err, 'Returned error: VM Exception while processing transaction: revert 403 -- Reason given: 403.');
    });

    it('should change price of property', async () => {
        await instance.registerUser('12345', {
            from: accounts[0],
            gas: 3000000
        });
        await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
            from: accounts[0],
            gas: 3000000
        });
        let property = await instance.onUpdatePrice(1,10, {
            from: accounts[0],
            gas: 3000000
        });
        assert.equal(property.receipt.status, true);
    });

    it('should not change price of property', async () => {
        let err = null;
        try {
            await instance.registerUser('12345', {
                from: accounts[0],
                gas: 3000000
            });
            await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
                from: accounts[0],
                gas: 3000000
            });
            await instance.onUpdatePrice(1,10, {
                from: accounts[1],
                gas: 3000000
            });
        } catch (error) {
            err = error.message;
        }
        assert.equal(err, 'Returned error: VM Exception while processing transaction: revert 403 -- Reason given: 403.');
    })
})