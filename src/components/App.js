import React, {Component} from 'react';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import KryptoBird from '../abis/Kryptobird.json';

class App extends Component{

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    };
 
    async loadWeb3() {
        const provider = await detectEthereumProvider();
        
 
        if(provider) {
            console.log('It is working');
            // Create web3 object
            window.web3 = new Web3(provider);
        } else {
            console.log('No Ethereum Wallet Detected');
        };
    };
 
    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await window.ethereum.request( {method: 'eth_requestAccounts'} );
        this.setState({account: accounts});
        // console.log(this.state.account);
        const networkId = await web3.eth.net.getId()
        const networkData = KryptoBird.networks[networkId]
        if(networkData){
            const abi = KryptoBird.abi;
            const address = networkData.address; 
            const contract = new web3.eth.Contract(abi, address)
    
            this.setState({contract})
            console.log(this.state.contract)


        }
    };

    constructor(props){
        super(props);
        this.state = {
            account: '',
            contract: null
        }

    }

    render(){
        return(
            <div>
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
                    <div className='navbar-brand col-sm-3 col-md-3 mr-0' style = {{color: 'white'}}>
                        Krypto Birdz NFTs (Non Fungible Tokens)
                    </div>
                    <ul className='navbar-nav px-3'> 
                        <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className='text-white'>
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>
            </div>
            
        )
    }

}

export default App;