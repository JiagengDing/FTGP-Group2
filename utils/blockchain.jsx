import abi from '@/artifacts/contracts/DappLottery.sol/DappLottery.json'
import address from '@/artifacts/contractAddress.json'
import { globalActions } from '@/store/global_reducer'
import { store } from '@/store'
import { ethers } from 'ethers'

const {
  updateWallet,
  setCurrentUser,
} = globalActions
const contractAddress = address.address
const contractAbi = abi.abi
let tx, ethereum

if (typeof window !== 'undefined') {
  ethereum = window.ethereum
}

const toWei = (num) => ethers.utils.parseEther(num.toString())

const getEthereumContract = async () => {
  const provider = new ethers.providers.Web3Provider(ethereum)
  const signer = provider.getSigner()
  const contract = new ethers.Contract(contractAddress, contractAbi, signer)
  return contract
}

const isWallectConnected = async (CometChat) => {
  try {
    if (!ethereum) return notifyUser('Please install Metamask')
    const accounts = await ethereum.request({ method: 'eth_accounts' })

    window.ethereum.on('chainChanged', (chainId) => {
      window.location.reload()
    })

    window.ethereum.on('accountsChanged', async () => {
      store.dispatch(updateWallet(accounts[0]))
      store.dispatch(setCurrentUser(null))
      logOutWithCometChat(CometChat).then(() => console.log('Logged out'))
      await isWallectConnected(CometChat)
    })

    if (accounts.length) {
      store.dispatch(updateWallet(accounts[0]))
    } else {
      store.dispatch(updateWallet(''))
      notifyUser('Please connect wallet.')
      console.log('No accounts found.')
    }
  } catch (error) {
    reportError(error)
  }
}

const connectWallet = async () => {
  try {
    if (!ethereum) return notifyUser('Please install Metamask')
    const accounts = await ethereum.request({ method: 'eth_requestAccounts' })
    store.dispatch(updateWallet(accounts[0]))
  } catch (error) {
    reportError(error)
  }
}
