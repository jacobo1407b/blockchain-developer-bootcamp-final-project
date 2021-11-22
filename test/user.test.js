
const AssetT = artifacts.require('AssetT');

let instance;

beforeEach(async () => {
    instance = await AssetT.new();
});

contract('AssetT', (accounts) => {
    it('should register a new user', async () => {
        let owner = await instance.registerUser('12345', {
            from: accounts[0],
            gas: 3000000
        });
        assert.equal(owner.receipt.status, true);
    });

    it('should not register a new user', async () => {
        let err = null;
        try {
            await instance.registerUser('12345', {
                from: accounts[0],
                gas: 3000000
            });
            let owner = await instance.registerUser('12345', {
                from: accounts[0],
                gas: 3000000
            });
            err = false
        } catch (e) {
            err = true
        }
        assert.equal(err, true);
    })

    it('should get user', async () => {
        await instance.registerUser('12345', {
            from: accounts[0],
            gas: 3000000
        });
        let user = await instance.getUser();
        assert.equal(user, '12345');
    });

    it('should get user not register', async () => {
        let user = await instance.getUser();
        assert.equal(user, '');
    })
})