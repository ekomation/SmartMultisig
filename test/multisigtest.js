const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-toolbox/network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect, assert } = require("chai");

describe("Testing that the contract is deployed successfully", async() => {
  
  
    it('should print the transaction signers', async() =>{
      const signers = await ethers.getSigners();
      supersigner = signers[0].address
      signerI = signers[1].address
      signerII = signers[2].address
      signerIII = signers[3].address
      signerIV = signers[4].address
      signerV = signers[9].address

      const walletsigner = [supersigner.toString(), signerI.toString()]

      console.log('signer 2', signerI)

      const Multisig = await ethers.getContractFactory('multisig');
      multisig = await Multisig.deploy([supersigner, signerI, signerII, signerIII, signerIV, signerV], 5);

      
      console.log('The super signer of the contract is :', supersigner);
      assert(multisig);
      console.log('Multisig contract deployed to address :', await multisig.target);


      console.log('carring out some transactions')

      runner1 = await multisig.connect(signers[1]).txCount()

      expect(runner1).to.equal(0)

      
      console.log('The number of transactions is: ', runner1)

    })
    it('Should be able to submit transactions', async() =>{


      const provider = new ethers.JsonRpcProvider('http://localhost:8545');
      const signers = await ethers.getSigners();
      supersigner = signers[0].address
      signerI = signers[1].address
      signerII = signers[2].address
      signerIII = signers[3].address
      signerIV = signers[4].address
      signerV = signers[9].address

      const walletsigner = [supersigner.toString(), signerI.toString()]

      console.log('signer 2', signerI)

      const Multisig = await ethers.getContractFactory('multisig');
      multisig = await Multisig.deploy([supersigner, signerI, signerII, signerIII, signerIV, signerV], 5);

      console.log('The balance of the account after 5 confirmations is')

      const gasPriceInGwei = 50; // Replace with your desired gas price in Gwei
      const gasLimit = 21000; // Replace with your desired gas limit

      const senderWallet = new ethers.Wallet('0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80', provider);
      const trx = await senderWallet.sendTransaction({
        to: multisig.target,
        value: ethers.parseUnits('100', 'ether'),
        gasPrice: ethers.parseUnits(gasPriceInGwei.toString(), 'gwei'), // Convert Gwei to Wei
        gasLimit: '21000',
        chainId: '31337',

      });

      console.log('The details of the transaction is ', await trx);
      console.log('The address of the reciepient is ', await multisig.target);
      const address = await multisig.target;
      contract_balance = await provider.getBalance(address);
      console.log('The contract balance after the first transaction is ', contract_balance)

      //getting the balance of signerI after sending the first transaction

      console.log('Updated balance of signerI after the first transaction is ', await provider.getBalance(multisig.target, 'latest'))





      //const amount = ethers.parseEther('2')
      //const tx = new ethers.Transaction()
      //tx.to = await multisig.target;
      //tx.value = amount;
      //tx.data = '0x';


      //await signers[0].transactionRequest({ from: supersigner, to: multisig.target, value: amount,})
      //console.log('Tx is', tx)

      console.log('sender wallet', senderWallet)
      const amount = ethers.parseEther('22')

     

      await multisig.connect(signers[0]).submitTransaction(signerI, amount, '0x');
      await multisig.submitTransaction(signerI, contract_balance, '0x');

     // console.log('Wallet balance before the first transfer call was made', await ethers.getBalance(signerI.address));
      await multisig.connect(signers[1]).confirmTransaction(1)


      console.log('The number of transactions submitted so far is', await provider.getBalance(signerI, 'latest'))
     // await multisig.connect(signers[1]).confirmTransaction(1)
      await multisig.connect(signers[2]).confirmTransaction(1)
      console.log('The address of the contract 2 is', multisig.target)
      
     await multisig.connect(signers[3]).confirmTransaction(1)
     await multisig.connect(signers[4]).confirmTransaction(1)
     await multisig.connect(signers[9]).confirmTransaction(1)

     await multisig.executeTransaction(1);

      console.log('The balance of the account after 5 confirmations is', await provider.getBalance(multisig.target, 'latest'))
      




    })

    



   // const Multisig = await ethers.getContractFactory("multisig");
   // multisig = await Multisig.deploy(, { value: lockedAmount });

   
});
