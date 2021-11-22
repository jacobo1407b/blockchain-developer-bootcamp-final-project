const AssetT = artifacts.require('AssetT');

let instance;

beforeEach(async () => {
    instance = await AssetT.new();
});

contract('AssetT', (accounts) => {
    it('should register a new property',async () => {
        await instance.registerUser('12345', {
            from: accounts[0],
            gas: 3000000
        });
        let property = await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
            from: accounts[0],
            gas: 3000000
        });
        assert.equal(property.receipt.status, true);
    });

    it('should not register a new property',async () => {
        let err = null;
        try {
            await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
                from: accounts[0],
                gas: 3000000
            });
            err = false
        } catch (e) {
            err = true
        }
        assert.equal(err, true);
    });

    it('should get property', async () => {
        await instance.registerUser('12345', {
            from: accounts[0],
            gas: 3000000
        });
        await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
            from: accounts[0],
            gas: 3000000
        });
        let property = await instance.getIdProperty(1);
        assert.equal(property.direccion, accounts[0]);
    });

    it('should return not autorize', async () => {
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
            await instance.getIdProperty(1,{
                from: accounts[1],
            });
        } catch (error) {
            err = error.message;
        }
        assert.equal(err, 'Returned error: VM Exception while processing transaction: revert 403');
    })

    it('should get array of propertys', async () => {
        await instance.registerUser('12345', {
            from: accounts[0],
            gas: 3000000
        });
        await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
            from: accounts[0],
            gas: 3000000
        });
        await instance.emitRegisterProperty('12345', '12345', '12345', 20, {
            from: accounts[0],
            gas: 3000000
        });
        let property = await instance.getProperty();
        assert.equal(property.length, 2);
    })
})