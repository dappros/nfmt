import React from 'react'
import Web3 from 'web3'
import Web3Modal from 'web3modal'
import Torus from '@toruslabs/torus-embed'
import WalletConnect from '@walletconnect/web3-provider'
import CoinbaseWalletSDK from '@coinbase/wallet-sdk'

import Header from './components/Header'

import { IAssetData } from './helpers/types'
import { apiGetAccountAssets } from './helpers/api'
import {
  getChainData
} from './helpers/utilities'

interface IAppState {
  fetching: boolean;
  address: string;
  web3: any;
  provider: any;
  connected: boolean;
  chainId: number;
  networkId: number;
  assets: IAssetData[];
  showModal: boolean;
  pendingRequest: boolean;
  result: any | null;
}

const INITIAL_STATE: IAppState = {
  fetching: false,
  address: '',
  web3: null,
  provider: null,
  connected: false,
  chainId: 1,
  networkId: 1,
  assets: [],
  showModal: false,
  pendingRequest: false,
  result: null
}

function initWeb3(provider: any) {
  const web3: any = new Web3(provider)

  web3.eth.extend({
    methods: [
      {
        name: 'chainId',
        call: 'eth_chainId',
        outputFormatter: web3.utils.hexToNumber
      }
    ]
  })

  return web3
}

class App extends React.Component<any, any> {
  public web3Modal: Web3Modal;
  public state: IAppState;

  constructor(props: any) {
    super(props)
    this.state = {
      ...INITIAL_STATE
    }

    this.web3Modal = new Web3Modal({
      network: this.getNetwork(),
      cacheProvider: true,
      providerOptions: this.getProviderOptions()
    })
  }

  // public componentDidMount() {
  //   if (this.web3Modal.cachedProvider) {
  //     this.onConnect();
  //   }
  // }

  public onConnect = async () => {
    const provider = await this.web3Modal.connect()

    await this.subscribeProvider(provider)

    await provider.enable()
    const web3: any = initWeb3(provider)

    const accounts = await web3.eth.getAccounts()

    const address = accounts[0]

    const networkId = await web3.eth.net.getId()

    const chainId = await web3.eth.chainId()

    await this.setState({
      web3,
      provider,
      connected: true,
      address,
      chainId,
      networkId
    })
    await this.getAccountAssets()
  };

  public subscribeProvider = async (provider: any) => {
    if (!provider.on) {
      return
    }
    provider.on('close', () => this.resetApp())
    provider.on('accountsChanged', async (accounts: string[]) => {
      await this.setState({ address: accounts[0] })
      await this.getAccountAssets()
    })
    provider.on('chainChanged', async (chainId: number) => {
      const { web3 } = this.state
      const networkId = await web3.eth.net.getId()
      await this.setState({ chainId, networkId })
      await this.getAccountAssets()
    })

    provider.on('networkChanged', async (networkId: number) => {
      const { web3 } = this.state
      const chainId = await web3.eth.chainId()
      await this.setState({ chainId, networkId })
      await this.getAccountAssets()
    })
  };

  public getNetwork = () => getChainData(this.state.chainId).network;

  public getProviderOptions = () => {
    const infuraId = process.env.REACT_APP_INFURA_ID
    const providerOptions = {
      walletconnect: {
        package: WalletConnect,
        options: {
          infuraId
        }
      },
      torus: {
        package: Torus
      },
      coinbasewallet: {
        package: CoinbaseWalletSDK,
        options: {
          appName: 'Web3Modal Example App',
          infuraId
        }
      }
    }
    return providerOptions
  };

  public getAccountAssets = async () => {
    const { address, chainId } = this.state
    this.setState({ fetching: true })
    try {
      // get account balances
      const assets = await apiGetAccountAssets(address, chainId)

      await this.setState({ fetching: false, assets })
    } catch (error) {
      console.error(error) // tslint:disable-line
      await this.setState({ fetching: false })
    }
  };

  public resetApp = async () => {
    console.log('resetApp')
    const { web3 } = this.state
    if (web3 && web3.currentProvider && web3.currentProvider.close) {
      await web3.currentProvider.close()
    }
    await this.web3Modal.clearCachedProvider()
    this.setState({ ...INITIAL_STATE })
  };

  public render = () => {
    const {
      address,
      connected,
      chainId,
    } = this.state

    return (
      <div className="App">
        <Header
          connected={connected}
          address={address}
          chainId={chainId}
          killSession={this.resetApp}
          onConnect={this.onConnect}
        ></Header>
      </div>
    )
  }
}

export default App
